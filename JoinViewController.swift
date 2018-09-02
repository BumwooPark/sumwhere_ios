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
import JDStatusBarNotification
import Validator

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

class JoinViewController: UIViewController{

  
  let disposeBag = DisposeBag()
  let provider = AuthManager.instance.provider
  
  let joinView = JoinView()
  
  lazy var viewModel = JoinViewModel(email: joinView.emailField.rx.text.orEmpty,
                                     password: joinView.passwordField.rx.text.orEmpty,
                                     passwordConfirm: joinView.passwordConfField.rx.text.orEmpty)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hero.isEnabled = true
  
    self.view.backgroundColor = .clear
    
    view = joinView
    joinView.infoAgreeLabel.delegate = self
  
    viewModel.emailValid
      .subscribeNext(weak: self) { (retainSelf) -> (Bool) -> Void in
      return {result in
        retainSelf.joinView.emailField.errorMessage = result ? nil : "이메일형식이 아닙니다!"
      }
    }.disposed(by: disposeBag)
    
    viewModel.passwordValid
      .subscribeNext(weak: self) { (retainSelf) -> (Bool) -> Void in
        return {result in
          retainSelf.joinView.passwordField.errorMessage = result ? nil : "패스워드는 6자에서 20자 사이입니다."
        }
    }.disposed(by: disposeBag)
    
    
    viewModel.passwordConfirmValid
      .subscribeNext(weak: self) { (retainSelf) -> (Bool) -> Void in
        return {result in
          retainSelf.joinView.passwordConfField.errorMessage = result ? nil : "비밀번호가 일치하지 않습니다."
        }
    }.disposed(by: disposeBag)
    
    
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
                          password: self.joinView.passwordField.text ?? String())
    
    provider.request(.signUp(model: model))
      .map(ResultModel<TokenModel>.self)
      .subscribe(onSuccess: {[weak self] (result) in
        guard let `self` = self else {return}
        
        if result.success{
          self.dismiss(animated: true, completion: {
            tokenObserver.onNext(result.result?.token ?? String())
          })
        }else{
          JDStatusBarNotification.show(withStatus: result.error?.details ?? "가입 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
        }
      }, onError: { (error) in
        JDStatusBarNotification.show(withStatus: "가입 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
      })
      .disposed(by: self.disposeBag)
  }
}

extension JoinViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    print("click")
  }
}
