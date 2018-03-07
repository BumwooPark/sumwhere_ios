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
  let provider = AuthManager.provider
  
  let joinView = JoinView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.isHeroEnabled = true 
    self.view.backgroundColor = .clear
    
    view = joinView
    joinView.infoAgreeLabel.delegate = self
    
    let emailVaild = joinView.emailField.rx.text
      .orEmpty
      .map {!re.findall("^[a-z0-9_+.-]+@([a-z0-9-]+\\.)+[a-z0-9]{2,4}$", $0).isEmpty}
      .share(replay: 1)

    let nicknameVaild = joinView.nicknameField.rx.text
      .orEmpty
      .map{ $0.length > 1}
      .share(replay: 1)

    let passwordVaild = joinView.passwordField.rx.text
      .orEmpty
      .map{!re.findall("^[A-Za-z0-9]{6,20}$", $0).isEmpty}
      .share(replay: 1)

    let passwordConfVaild = joinView.passwordConfField.rx.text
      .map{[weak self] in
        self?.joinView.passwordField.text == $0
      }.share(replay: 1)

    Observable<Bool>.combineLatest(emailVaild, nicknameVaild, passwordVaild, passwordConfVaild)
    {return $0 && $1 && $2 && $3}
      .subscribe(onNext: { (vaild) in
      })
      .disposed(by: disposeBag)
    
    joinView.joinButton
      .rx
      .controlEvent(.touchUpInside)
      .bind(onNext: signUp)
      .disposed(by: disposeBag)
    
    joinView.backButton.rx.controlEvent(.touchUpInside)
      .subscribe { [weak self](event) in
        self?.presentingViewController?.dismiss(animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    self.view.heroID = "joinview"
    isHeroEnabled = true
    self.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    joinView.emailField.errorMessage = ""
    joinView.nicknameField.errorMessage = ""
    joinView.endEditing(true)
  }
  
  private func signUp(){
    provider.request(.signUp(email: self.joinView.emailField.text ?? "",
                             password: self.joinView.passwordField.text ?? "",
                             username: self.joinView.nicknameField.text ?? ""))
      .filter(statusCodes: 200...201)
      .subscribe(onSuccess: { (response) in
        log.info(response)
      }) { (error) in
        log.error(error)
    }.disposed(by: disposeBag)
  }
}

extension JoinViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    print("click")
  }
}


