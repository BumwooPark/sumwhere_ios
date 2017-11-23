//
//  WelcomeViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField
import SnapKit
import Spring
import Hero
import Moya
import SwiftyJSON
import JDStatusBarNotification
import Firebase

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class WelcomeViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let provider = AuthManager.sharedManager.provider
  let joinVC = JoinViewController()
  
  let imageView: UIImageView = {
    let image = UIImageView(image: #imageLiteral(resourceName: "bare-1985858_1920"))
    image.contentMode = .scaleAspectFill
    image.alpha = 0.9
    image.heroID = "backImageView"
    return image
  }()
  
  let zipImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Rectangle 6"))
    return imageView
  }()
  
  let kakaoButton: KOLoginButton = {
    let button = KOLoginButton()
    button.setTitle("카카오톡으로 로그인", for: .normal)
    button.layer.cornerRadius = 10
    return button
  }()
  
  lazy var emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "E-mail"
    field.placeholderColor = .black
    field.lineColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    field.keyboardType = .emailAddress
    field.returnKeyType = .done
    field.heroID = "emailField"
    field.delegate = self
    return field
  }()
  
  lazy var passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "Password"
    field.placeholderColor = .black
    field.lineColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    field.returnKeyType = .done
    field.isSecureTextEntry = true
    field.heroID = "passwordField"
    field.delegate = self
    return field
  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    button.layer.cornerRadius = 10
    button.isEnabled = false
    return button
  }()
  
  let joinButton: UIButton = {
    let button = UIButton()
    button.setTitle("가입하기", for: .normal)
    button.layer.cornerRadius = 10
    button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    return button
  }()
  
  var constaint: Constraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(imageView)
    view.insertSubview(kakaoButton, aboveSubview: imageView)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(loginButton)
    view.addSubview(joinButton)
    view.addSubview(zipImageView)
    
    // Settings
    
    JTAlertSetting()
    heroSetting()
    addConstraint()
    
    let viewModel = WelcomeViewModel(emailText: emailField.rx.text.orEmpty.asDriver()
      , passwordText: passwordField.rx.text.orEmpty.asDriver())
    
    viewModel.credentialsValid
      .drive(onNext: {[weak self] vaild in
        self?.loginButton.isEnabled = vaild
        self?.loginButton.backgroundColor = vaild ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
      }).disposed(by: disposeBag)
    
    joinButton.rx.tap
      .subscribe {[weak self] (_) in
        guard let strongSelf = self else {return}
        strongSelf.present(strongSelf.joinVC, animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    
    loginButton.rx.tap
      .throttle(0.3, scheduler: MainScheduler.instance)
      .withLatestFrom(viewModel.credentialsValid)
      .filter{$0}
      .bind(onNext: network)
      .disposed(by: disposeBag)
    
    kakaoButton.rx.controlEvent(.touchUpInside)
      .throttle(0.3, scheduler: MainScheduler.instance)
      .bind(onNext: kakaoLogin)
      .disposed(by: disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: {[weak self] frame in
        DispatchQueue.main.async {
          UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
            self?.constaint.update(offset: -(frame/4))
            self?.view.setNeedsLayout()
          }, completion: nil)
        }
      }).disposed(by: disposeBag)
    
    UIView.animate(withDuration: 20, delay: 0, options: .curveLinear, animations: {
      self.imageView.transform = CGAffineTransform(translationX: -250, y: 0)
    }) { (status: Bool) in
      log.error(status)
    }
  }
  
  
  /// 로그인 처리
  ///
  // TODO: - 심플하게 처리하는 방법이 없을지 생각
  private func network(result: Bool){
    AuthManager.sharedManager.provider.request(.defaultLogin(email: emailField.text!, password: passwordField.text!))
      .map(LoginModel.self)
      .subscribe(onSuccess: { (model) in
        if model.result.statusCode == 200{
          UserDefaults.standard.set(model.result.accessToken, forKey: "access_token")
          UserDefaults.standard.set(model.result.refreshToken, forKey: "refresh_token")
          UserDefaults.standard.set(true, forKey: "login")
          AppDelegate.instance?.window?.rootViewController = MainTabBarController()
        }else{
          JDStatusBarNotification.show(withStatus: model.result.message, dismissAfter: 2, styleName: "loginfail")
        }
      }, onError: {
        log.error($0)
        //    TODO: Alert창으로 서버 오류를 표기해야됨
      }).disposed(by: disposeBag)
  }
  
  private func addConstraint(){
    
    zipImageView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(100)
      make.height.equalTo(150)
      make.width.equalTo(150)
    }
    
    emailField.snp.makeConstraints {[weak self] (make) in
      make.centerX.equalToSuperview()
      self?.constaint = make.centerY.equalToSuperview().constraint
      make.height.equalTo(40)
      make.width.equalToSuperview().dividedBy(1.5)
    }
    
    passwordField.snp.makeConstraints { (make) in
      make.centerX.equalTo(emailField)
      make.width.equalTo(emailField)
      make.height.equalTo(emailField)
      make.top.equalTo(emailField).offset(60)
    }
    
    loginButton.snp.makeConstraints { (make) in
      make.top.equalTo(passwordField).offset(60)
      make.height.equalTo(passwordField)
      make.width.equalTo(passwordField)
      make.centerX.equalToSuperview()
    }
    
    joinButton.snp.makeConstraints { (make) in
      make.top.equalTo(loginButton).offset(60)
      make.height.equalTo(loginButton)
      make.width.equalTo(loginButton)
      make.centerX.equalToSuperview()
    }
    
    kakaoButton.snp.makeConstraints { (make) in
      make.top.equalTo(joinButton).offset(60)
      make.height.equalTo(40)
      make.width.equalTo(passwordField)
      make.centerX.equalToSuperview()
    }
  }
  
  private func JTAlertSetting(){
    JDStatusBarNotification.addStyleNamed("loginfail") {
      $0?.barColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
      $0?.textColor = .white
      return $0
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  private func heroSetting(){
    self.view.heroID = "welcomeview"
  }
  
  
  //  TODO: - 토큰 방식으로 변경 예정
  private func kakaoLogin(){
    let session: KOSession = KOSession.shared()
    
    if session.isOpen() {
      session.close()
    }
    
    session.open(completionHandler: {[weak self] (error) -> Void in
      guard let `self` = self else {return}
      if KOSession.shared().isOpen(){
        KOSessionTask.meTask{(result, error) in
          if (result != nil){
            guard let user = result as? KOUser else {return}
            let email = user.email ?? ""
            let userId = "\(user.id ?? 0)"
            let nickname = user.property(forKey: KOUserNicknamePropertyKey) as? String
            let fcmtoken = Messaging.messaging().fcmToken ?? ""
            
            self.provider.request(.login(email: email
              , kakao_id: "kakao_\(userId)"
              , password: ""
              , nickname: nickname ?? ""
              , fcm_token: fcmtoken
              , type: "kakao"))
              .map(LoginModel.self)
              .subscribe({ (event) in
                switch event{
                case .success(let model):
                  log.info(model.result)
                case .error(let error):
                  if let moyaError: MoyaError? = error as? MoyaError{
                    log.error(moyaError?.response?.statusCode)
                  }
                }
              }).disposed(by: self.disposeBag)
          }
        }
      }
    }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue),
                   NSNumber(value: KOAuthType.account.rawValue)])
  }
}


extension WelcomeViewController: UITextFieldDelegate{
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
