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
import TTTAttributedLabel
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class LoginViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let provider = AuthManager.provider
  let joinVC = JoinViewController()
  
  lazy var loginView: LoginView = {
    let view = LoginView(frame: self.view.bounds)
    view.joinLabel.delegate = self
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = loginView
    self.view.hero.id = "loginToDefaultLogin"
    
//    let viewModel = WelcomeViewModel(emailText: loginView.emailField.rx.text.orEmpty.asDriver()
//      , passwordText: loginView.passwordField.rx.text.orEmpty.asDriver())
//
//    viewModel.credentialsValid
//      .drive(onNext: {[weak self] vaild in
//        self?.loginView.loginButton.isEnabled = vaild
//        self?.loginView.loginButton.backgroundColor = vaild ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
//      }).disposed(by: disposeBag)
    
    loginView.loginButton.rx
      .tap
      .bind(onNext: signIn)
      .disposed(by: disposeBag)

    loginView.kakaoButton.rx
      .controlEvent(.touchUpInside)
      .throttle(0.3, scheduler: MainScheduler.instance)
      .bind(onNext: kakaoLogin)
      .disposed(by: disposeBag)
    
    loginView.faceBookButton.rx
      .tap
      .map {return FBSDKLoginManager()}
      .bind(onNext: facebookLogin)
      .disposed(by: disposeBag)
  }
  
  private func signIn(){
    log.info("click")
    present(DefaultLoginViewController(), animated: true, completion: nil)
  }
  
  private func facebookLogin(manager: FBSDKLoginManager){
    
    LoginKit.facebookLogin(manager: manager, Permissions: ["public_profile","email"], from: self) {[weak self] (result) in
      guard let `self` = self else {return}
      
      if result{
      AuthManager.provider
        .request(.facebook(access_token: FBSDKAccessToken.current().tokenString))
        .filterSuccessfulStatusCodes()
        .map(ResultModel.self)
        .map{ $0.result["token", default: ""]}
        .subscribe(onSuccess: { (token) in
          tokenObserver.onNext(token)
        }, onError: { (error) in
          JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
        })
        .disposed(by: self.disposeBag)
      }else{
        JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  private func kakaoLogin(){
    LoginKit.kakaoLogin {[weak self] (result) in
      guard let `self` = self else {return}
      if result{
        AuthManager.provider
          .request(.kakao(access_token: KOSession.shared().token.accessToken))
          .filterSuccessfulStatusCodes()
          .map(ResultModel.self)
          .map{ $0.result["token", default: ""]}
          .subscribe(onSuccess: { (token) in
            tokenObserver.onNext(token)
          }, onError: { (error) in
            JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
          })
          .disposed(by: self.disposeBag)
      }else{
        JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
      }
    }
  }
}
extension LoginViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    present(JoinViewController(), animated: true, completion: nil)
  }
}
