//
//  회원이 아닐경우 맨처음 보이는 ViewController
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField
import SnapKit
import Moya
import SwiftyJSON
import JDStatusBarNotification
import Firebase
import CryptoSwift
import Security
import FBSDKLoginKit
import SwiftyUserDefaults
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class WelcomeViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let provider = AuthManager.sharedManager.provider
  let joinVC = JoinViewController()
  
  lazy var welcomeView: WelComeView = {
    let view = WelComeView(frame: self.view.bounds)
    view.emailField.delegate = self
    view.passwordField.delegate = self
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = welcomeView

    heroSetting()
    
    let viewModel = WelcomeViewModel(emailText: welcomeView.emailField.rx.text.orEmpty.asDriver()
      , passwordText: welcomeView.passwordField.rx.text.orEmpty.asDriver())
    
    viewModel.credentialsValid
      .drive(onNext: {[weak self] vaild in
        self?.welcomeView.loginButton.isEnabled = vaild
        self?.welcomeView.loginButton.backgroundColor = vaild ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
      }).disposed(by: disposeBag)
    
    welcomeView.joinButton
      .rx
      .tap
      .subscribe {[weak self] (_) in
        guard let strongSelf = self else {return}
        strongSelf.present(strongSelf.joinVC, animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    welcomeView.loginButton.rx.tap
      .bind(onNext: signIn)
      .disposed(by: disposeBag)

    welcomeView.kakaoButton.rx
      .controlEvent(.touchUpInside)
      .throttle(0.3, scheduler: MainScheduler.instance)
      .bind(onNext: kakaoLogin)
      .disposed(by: disposeBag)
    
    welcomeView.faceBookButton.rx
      .tap
      .map {return FBSDKLoginManager()}
      .bind(onNext: facebookLogin)
      .disposed(by: disposeBag)
    
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: {[weak self] frame in
        DispatchQueue.main.async {
          UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {[weak self] in
            self?.welcomeView.constaint.update(offset: -(frame/4))
            self?.welcomeView.setNeedsLayout()
          }, completion: nil)
        }
      }).disposed(by: disposeBag)
  }
  
  private func signIn(){
    provider.request(.signIn(email: welcomeView.emailField.text ?? "", password: welcomeView.passwordField.text ?? ""))
      .filter(statusCode: 200)
      .mapJSON()
      .map{JSON($0)}
      .subscribe(onSuccess: { (json) in
        Defaults[.isLogin] = true
        Defaults[.token] = json["access_token"].stringValue
      }) { error in
        JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
    }.disposed(by: disposeBag)
  }
  
  private func facebookLogin(manager: FBSDKLoginManager){
    manager.logIn(withReadPermissions: ["public_profile","email"], from: self) {[weak self] (result, error) in
      guard let retainSelf = self else {return}
      if (error != nil){
        log.info(error!)
      }else{
        retainSelf.provider.request(.facebook(access_token: FBSDKAccessToken.current().tokenString))
          .filter(statusCode: 200)
          .mapJSON()
          .map{JSON($0)}
          .subscribe(onSuccess: { (json) in
            Defaults[.isLogin] = true
            Defaults[.token] = json["access_token"].stringValue
          }, onError: { (error) in
            log.error(error)
          }).disposed(by:retainSelf.disposeBag)
      }
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

    if session.isOpen() {session.close()}
    
    session.open(completionHandler: {[weak self] (error) -> Void in
      guard let retainSelf = self else {return}
      if KOSession.shared().isOpen(){
        KOSessionTask.meTask{(result, error) in
          if (result != nil){
            let token = KOSession.shared().accessToken
            retainSelf.provider.request(.kakao(access_token: token!))
              .filter(statusCode: 200)
              .mapJSON()
              .map{JSON($0)}
              .subscribe(onSuccess: { (json) in
                Defaults[.isLogin] = true
                Defaults[.token] = json["access_token"].stringValue
              }, onError: { (error) in
                log.error(error)
              }).disposed(by: retainSelf.disposeBag)
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
