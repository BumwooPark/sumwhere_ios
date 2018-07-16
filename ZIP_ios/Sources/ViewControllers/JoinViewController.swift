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
import LGButton
import Moya
import SwiftyJSON
import TTTAttributedLabel
import Firebase
import PySwiftyRegex
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
    hero.isEnabled = true
  
    self.view.backgroundColor = .clear
    
    view = joinView
    joinView.infoAgreeLabel.delegate = self
    
    let emailVaild = joinView.emailField.rx.text
      .orEmpty
      .map {!re.findall("^[a-z0-9_+.-]+@([a-z0-9-]+\\.)+[a-z0-9]{2,4}$", $0).isEmpty}
      .skip(2)
      .share(replay: 1)
    
    joinView.nicknameField.rx
      .text
      .orEmpty
      .skip(2)
      .flatMap {
        AuthManager.provider.request(.nicknameConfirm(nickname: $0))
          .filterSuccessfulStatusCodes()
          .map(NicknameModel.self)
          .map{$0.result}
          .catchErrorJustReturn(false)
      }.subscribe(onNext: { [weak self](result) in
        guard let `self` = self else {return}
        if result{
          self.joinView.nicknameField.errorMessage = String()
        }else{
          self.joinView.nicknameField.errorMessage = "이미 존재합니다!"
        }
      }).disposed(by: disposeBag)
    
    let passwordVaild = joinView.passwordField.rx.text
      .orEmpty
      .map{!re.findall("^[A-Za-z0-9]{6,20}$", $0).isEmpty}
      .skip(1)
      .share(replay: 1)

    let passwordConfVaild = joinView.passwordConfField.rx.text
      .map{[weak self] in
        self?.joinView.passwordField.text == $0
      }.share(replay: 2)
    
    emailVaild
      .subscribe(onNext: {[weak self] (result) in
        guard let `self` = self else {return}
      if !result{
        self.joinView.emailField.errorMessage = "이메일 형식이 아니에요!"
      }else{
        self.joinView.emailField.errorMessage = String()
      }
    }).disposed(by: disposeBag)
    
    passwordConfVaild
      .subscribe(onNext: {[weak self] (result) in
      guard let `self` = self else {return}
        if !result{
          self.joinView.passwordConfField.errorMessage = "비밀번호가 동일하지 않아요!"
        }else {
          self.joinView.passwordConfField.errorMessage = String()
        }
    }).disposed(by: disposeBag)
    

    Observable<Bool>.combineLatest(passwordVaild, passwordConfVaild)
    {return $0 && $1}
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
    
    view.hero.id = String(describing: JoinViewController.self)
    hero.isEnabled = true
    hero.modalAnimationType = .selectBy(presenting: .push(direction: .up), dismissing: .pull(direction: .down))
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    joinView.emailField.errorMessage = ""
    joinView.endEditing(true)
  }
  
  private func signUp(){
    
    let model = JoinModel(email: self.joinView.emailField.text ?? String(),
                          password: self.joinView.passwordField.text ?? String(),
                          nickname: self.joinView.nicknameField.text ?? String())
    
    provider.request(.signUp(model: model))
      .map(ResultModel<TokenModel>.self)
      .subscribe(onSuccess: {[weak self] (result) in
        guard let `self` = self else {return}
        
        if result.success{
          self.dismiss(animated: true, completion: {
            tokenObserver.onNext(result.result?.token ?? String())
          })
        }else{
          JDStatusBarNotification.show(withStatus: result.error?.details ?? "가입 실패", dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
        }
      }, onError: { (error) in
        JDStatusBarNotification.show(withStatus: "가입 실패", dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
      })
      .disposed(by: self.disposeBag)
  }
}

extension JoinViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    print("click")
  }
}
