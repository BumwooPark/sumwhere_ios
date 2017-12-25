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
import ReSwift
import CryptoSwift
import Security

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class WelcomeViewController: UIViewController, StoreSubscriber{
  typealias StoreSubscriberStateType = AppState
  
  let disposeBag = DisposeBag()
  let provider = AuthManager.sharedManager.provider
  let joinVC = JoinViewController()
  
  lazy var welcomeView: WelComeView = {
    let view = WelComeView(frame: self.view.bounds)
    view.emailField.delegate = self
    view.passwordField.delegate = self
    return view
  }()
  
  func newState(state: AppState) {
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = welcomeView

    // Settings
    
    JTAlertSetting()
    heroSetting()
    
    
    let viewModel = WelcomeViewModel(emailText: welcomeView.emailField.rx.text.orEmpty.asDriver()
      , passwordText: welcomeView.passwordField.rx.text.orEmpty.asDriver())
    
    viewModel.credentialsValid
      .drive(onNext: {[weak self] vaild in
        self?.welcomeView.loginButton.isEnabled = vaild
        self?.welcomeView.loginButton.backgroundColor = vaild ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
      }).disposed(by: disposeBag)
    
    welcomeView.joinButton.rx.tap
      .subscribe {[weak self] (_) in
        guard let strongSelf = self else {return}
        strongSelf.present(strongSelf.joinVC, animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    welcomeView.loginButton.rx.tap
      .throttle(0.3, scheduler: MainScheduler.instance)
      .withLatestFrom(viewModel.credentialsValid)
      .filter{$0}
      .bind(onNext: network)
      .disposed(by: disposeBag)
    
    welcomeView.kakaoButton.rx.controlEvent(.touchUpInside)
      .throttle(0.3, scheduler: MainScheduler.instance)
      .bind(onNext: kakaoLogin)
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
   
    
    UIView.animate(withDuration: 20, delay: 0, options: .curveLinear, animations: {[weak self] in
      self?.welcomeView.imageView.transform = CGAffineTransform(translationX: -250, y: 0)
    }) { (status: Bool) in
      log.error(status)
    }
  }

  
  /// 로그인 처리
  ///
  // TODO: - 심플하게 처리하는 방법이 없을지 생각
  private func network(result: Bool){
    
    do {
      let aes = try AES(key: "bumwoopark", iv: "zipbumwoopark") // aes128
      guard let ciphertext = try aes.encrypt(Array(welcomeView.passwordField.text!.utf8)).toBase64() else {return}
      self.provider.request(.login(email: welcomeView.emailField.text!, password: ciphertext))
        .filter(statusCodes: 200...400)
        .map(TokenModel.self)
        .subscribe(onSuccess: { (model) in
          UserDefaults.standard.set(true, forKey: "login")
        }) { (error) in
          JDStatusBarNotification.show(withStatus: "계정이 없거나 이메일 또는 비밀번호가 다릅니다", dismissAfter: 2, styleName: "loginfail")
        }.disposed(by: disposeBag)
    } catch { }
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
            let token = KOSession.shared().accessToken
//            self.provider.request(.kakaoLogin(kakaoToken: token!))
//              .filter(statusCode: 200)
//              .subscribe(onSuccess: { (response) in
//                log.info(response.description)
//              }, onError: { (error) in
//                log.error(error)
//              }).disposed(by: self.disposeBag)

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
