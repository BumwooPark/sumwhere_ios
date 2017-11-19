//
//  SMSCertViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 9..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import Spring
import Firebase
import PhoneNumberKit
import JDStatusBarNotification
import Hero
import Moya
import SwiftyJSON
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif


class SMSCertViewController: UIViewController{
  
  let provider = AuthManager.sharedManager.provider
  let disposeBag = DisposeBag()
  
  var userEmail: String?
  
  let phoneField: PhoneNumberTextField = {
    let field = PhoneNumberTextField()
    field.defaultRegion = "KR"
    field.placeholder = "전화번호 입력"
    field.textAlignment = .center
    return field
  }()
  
  let authField: SpringTextField = {
    let field = SpringTextField()
    field.placeholder = "인증번호"
    field.keyboardType = .numberPad
    field.textAlignment = .center
    field.animation = "squeezeLeft"
    field.curve = "easeInSine"
    field.duration = 1
    field.isHidden = true
    return field
  }()
  
  let authNumberButton: SpringButton = {
    let button = SpringButton()
    button.setTitle("인증번호 받기", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  let confirmButton: SpringButton = {
    let button = SpringButton()
    button.setTitle("인증하기", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.animation = "squeezeRight"
    button.curve = "easeInSine"
    button.duration = 1
    button.isHidden = true
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.isHeroEnabled = true 
    self.view.backgroundColor = .white
    self.view.addSubview(authField)
    self.view.addSubview(phoneField)
    self.view.addSubview(authNumberButton)
    self.view.addSubview(confirmButton)
    
    self.heroModalAnimationType = .pageIn(direction: .left)
    addConstraint()
    
    let viewModel = SMSViewModel(smsText: phoneField.rx.text.orEmpty.asDriver()
      , authText: authField.rx.text.orEmpty.asDriver())
    
    JDStatusBarNotification.addStyleNamed("phoneSuccess") {
      $0?.barColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      $0?.textColor = .white
      return $0
    }
    
    JDStatusBarNotification.addStyleNamed("phoneFail") {
      $0?.barColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
      $0?.textColor = .white
      return $0
    }
    
    authNumberButton.rx.tap
      .withLatestFrom(viewModel.phoneNumberVaild)
      .observeOn(MainScheduler.instance)
      .subscribe { [unowned self](event) in
        if event.element!{
          self.authNumberButton.isHidden = true
          self.authField.isHidden = false
          self.confirmButton.isHidden = false
          self.confirmButton.animate()
          self.authField.animate()
          viewModel.sendAction(email: self.userEmail ?? ""
          , phoneNumber: self.phoneField.text!)
        }else{
          JDStatusBarNotification.show(withStatus: "전화번호 형식이 잘못되었습니다.", dismissAfter: 2, styleName: "phoneFail")
        }
    }.disposed(by: disposeBag)
    
    confirmButton.rx
      .tap
      .withLatestFrom(viewModel.authVaild)
      .observeOn(MainScheduler.instance)
      .subscribe { [unowned self] (event) in
        viewModel.credentialVaild(code: self.authField.text!){ (result) in
          if result{
            
          }else{
            JDStatusBarNotification.show(withStatus: "인증번호가 맞지 않습니다.", dismissAfter: 2, styleName: "phoneFail")
          }
        }
    }.disposed(by: disposeBag)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.phoneField.becomeFirstResponder()
  }
  
  private func addConstraint(){
    
    phoneField.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(100)
      make.width.equalToSuperview().dividedBy(2)
      make.centerX.equalToSuperview()
    }
    
    authNumberButton.snp.makeConstraints { (make) in
      make.top.equalTo(phoneField.snp.bottom).offset(50)
      make.centerX.equalToSuperview()
    }
    
    authField.snp.makeConstraints { (make) in
      make.top.equalTo(authNumberButton.snp.bottom).offset(100)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().dividedBy(2)
    }
    
    confirmButton.snp.makeConstraints { (make) in
      make.top.equalTo(authField.snp.bottom).offset(100)
      make.centerX.equalToSuperview()
    }
  }
}
