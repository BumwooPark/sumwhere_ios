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

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class WelcomeViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  
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
  
  let kobutton: KOLoginButton = {
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
    view.insertSubview(kobutton, aboveSubview: imageView)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(loginButton)
    view.addSubview(joinButton)
    view.addSubview(zipImageView)
    
    heroSetting()
    addConstraint()
    let emailObserver = emailField.rx.text.map{$0!.isEmpty}
    let passwordObserver = passwordField.rx.text.map{$0!.isEmpty}
    
    
    Observable.combineLatest(emailObserver, passwordObserver) {
      return ($0, $1)
      }.subscribe {[weak self] (tuple) in
        guard let element = tuple.element else {return}
        if element == (false,false){
          self?.loginButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
          self?.loginButton.isEnabled = true
        }else{
          self?.loginButton.backgroundColor = .gray
          self?.loginButton.isEnabled = false
        }
      }.disposed(by: disposeBag)
    
    
    let samplevc = MainTabBarController()
    loginButton.rx.controlEvent(.touchUpInside)
      .subscribe {[weak self] (_) in
        self?.present(samplevc, animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    
    joinButton.rx.controlEvent(.touchUpInside)
      .subscribe {[weak self] (_) in
        guard let strongSelf = self else {return}
        strongSelf.present(strongSelf.joinVC, animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: {[weak self] frame in
        DispatchQueue.main.async {
          UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
            self?.constaint.update(offset: -(frame/4))
            self?.view.setNeedsLayout()
          }, completion: nil)
        }
      }).disposed(by: disposeBag)
    
    kobutton.rx.controlEvent(.touchUpInside)
      .throttle(0.3, scheduler: MainScheduler.instance)
      .bind(onNext: kakaoLogin)
      .disposed(by: disposeBag)
    
    UIView.animate(withDuration: 20, delay: 0, options: .curveLinear, animations: {
      self.imageView.transform = CGAffineTransform(translationX: -250, y: 0)
    }) { (status: Bool) in
      print(status)
    }
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
    
    kobutton.snp.makeConstraints { (make) in
      make.top.equalTo(joinButton).offset(60)
      make.height.equalTo(40)
      make.width.equalTo(passwordField)
      make.centerX.equalToSuperview()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  private func heroSetting(){
    self.view.heroID = "welcomeview"
  }
  
  private func kakaoLogin(){
    let session: KOSession = KOSession.shared()
    log.info(session)
    
    if session.isOpen() {
      session.close()
    }
    
    session.open(completionHandler: { (error) -> Void in
      
      if !session.isOpen() {
        switch ((error as NSError!).code) {
        case Int(KOErrorCancelled.rawValue):
          break;
        default:
          UIAlertView(title: "에러", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "확인").show()
          break;
        }
      }
    }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue), NSNumber(value: KOAuthType.account.rawValue)])
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




