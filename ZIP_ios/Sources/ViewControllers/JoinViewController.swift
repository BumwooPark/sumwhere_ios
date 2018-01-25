//
//  JoinViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import Hero
import SkyFloatingLabelTextField
import Spring
import PySwiftyRegex
import LGButton
import Moya
import SwiftyJSON
import TTTAttributedLabel
import Firebase
import CryptoSwift
import JDStatusBarNotification



#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

class JoinViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let provider = AuthManager.sharedManager.provider
  
  let joinView = JoinView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.isHeroEnabled = true 
    self.view.backgroundColor = .clear
    
    view = joinView
    joinView.infoAgreeLabel.delegate = self
    
    
//    let emailVaild = joinView.emailField.rx.text
//      .orEmpty
//      .map {!re.findall("^[a-z0-9_+.-]+@([a-z0-9-]+\\.)+[a-z0-9]{2,4}$", $0).isEmpty}
//      .share(replay: 1)
//
//    let nicknameVaild = joinView.nicknameField.rx.text
//      .orEmpty
//      .map{ $0.length > 1}
//      .share(replay: 1)
//
//    let passwordVaild = joinView.passwordField.rx.text
//      .orEmpty
//      .map{!re.findall("^[A-Za-z0-9]{6,20}$", $0).isEmpty}
//      .share(replay: 1)
//
//    let passwordConfVaild = joinView.passwordConfField.rx.text
//      .map{[weak self] in
//        self?.joinView.passwordField.text == $0
//      }.share(replay: 1)
//
//    Observable<Bool>.combineLatest(emailVaild, nicknameVaild, passwordVaild, passwordConfVaild)
//    {return $0 && $1 && $2 && $3}
//      .bind(to: joinView.joinButton.rx.isEnabled)
//      .disposed(by: disposeBag)
    
    //TODO: 해야됨
    joinView.joinButton.rx.controlEvent(.touchUpInside)
      .bind(onNext: api)
      .disposed(by: disposeBag)
    
    joinView.backButton.rx.controlEvent(.touchUpInside)
      .subscribe { [weak self](event) in
        self?.presentingViewController?.dismiss(animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    self.view.heroID = "joinview"
    isHeroEnabled = true
    self.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
  }
  
  private func api(){
    
    joinView.joinButton.showLoading()
    let fcmtoken = Messaging.messaging().fcmToken ?? ""
    log.info(fcmtoken)
    
    do {
      let aes = try AES(key: "bumwooparkbumwoo", iv: "bumwooparkbumwoo") // aes256
      guard let ciphertext = try aes.encrypt(Array(joinView.passwordField.text!.utf8)).toBase64() else {return}
    
      provider
        .request(.join(email: joinView.emailField.text!, kakao_id: ""
          , password: ciphertext
          , nickname: joinView.nicknameField.text!
          , fcmToken: fcmtoken
          )
        )
        .filter(statusCode: 200)
        .subscribe(onSuccess: { [weak self](_) in
          JDStatusBarNotification.show(withStatus: "환영합니다", dismissAfter: 3, styleName: JDType.LoginSuccess.rawValue)
          self?.dismiss(animated: true, completion: nil)
          }, onError: { (error) in
            log.error(error)
        })
    }catch let error{log.error(error)}
    joinView.joinButton.hideLoading()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    joinView.emailField.errorMessage = ""
    joinView.nicknameField.errorMessage = ""
    joinView.endEditing(true)
  }
  
  private func JTAlertSetting(){
    JDStatusBarNotification.addStyleNamed(JDType.LoginSuccess.rawValue) {
      $0?.barColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      $0?.textColor = .white
      return $0
    }
  }
}

extension JoinViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    print("click")
  }
}


