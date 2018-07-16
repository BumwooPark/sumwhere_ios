//
//  DefaultLoginViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 16..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import SkyFloatingLabelTextField
import Hero
import LGButton
import RxSwift
import RxCocoa
import RxOptional
import JDStatusBarNotification

final class DefaultLoginViewController: UIViewController{
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  let zipImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Rectangle 6"))
    imageView.hero.id = "zipImageView"
    return imageView
  }()
  
  private let emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.lineColor = .black
    field.lineErrorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.selectedLineColor = .blue
    field.selectedTitleColor = .blue
    field.placeholder = "이메일"
    field.placeholderColor = .black
    field.keyboardType = .emailAddress
    field.returnKeyType = .done
    return field
  }()
  
  private let passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.lineColor = .black
    field.lineErrorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.selectedLineColor = .blue
    field.selectedTitleColor = .blue
    field.placeholder = "비밀번호"
    field.placeholderColor = .black
    field.isSecureTextEntry = true
    field.returnKeyType = .done
    field.keyboardType = .asciiCapable
    return field
  }()
  
  private let loginButton: LGButton = {
    let button = LGButton()
    button.titleString = "로그인"
    button.titleFontSize = 15
    button.titleColor = .white
    button.fullyRoundedCorners = true
    button.gradientStartColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    button.gradientEndColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    button.gradientHorizontal = true
    button.shadowColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    return button
  }()
  
  private let dismissButton: LGButton = {
    let button = LGButton()
    button.titleString = "취소"
    button.titleFontSize = 15
    button.titleColor = .white
    button.fullyRoundedCorners = true
    button.gradientStartColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    button.gradientEndColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    button.gradientHorizontal = true
    button.shadowColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    return button
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.hero.id = "loginToDefaultLogin"
    hero.isEnabled = true
    view.addSubview(zipImageView)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(loginButton)
    view.addSubview(dismissButton)
    
    behavior()
    heroConfig()
    view.setNeedsUpdateConstraints()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  private func behavior(){
    
    loginButton.rx
      .controlEvent(.touchUpInside)
      .subscribe(onNext: {[weak self] (_) in
        guard let `self` = self else {return}
        self.login()
      }).disposed(by: disposeBag)

    dismissButton.rx
      .controlEvent(.touchUpInside)
      .subscribe(onNext: {[weak self] (_) in
        guard let `self` = self else {return}
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }

  /// API Login
  private func login(){
    AuthManager.provider.request(.signIn(email: emailField.text ?? String(), password: passwordField.text ?? String()))
      .map(ResultModel.self)
      .subscribe(onSuccess: {[weak self] (result) in
        guard let `self` = self else {return}
        if result.success{
          self.dismiss(animated: true, completion: {tokenObserver.onNext(result.result["token",default: String()])})
        }else{
          JDStatusBarNotification.show(withStatus: result.error.details, dismissAfter: 1, styleName: JDType.LoginFail.rawValue)
        }
      }) { (error) in
         log.error(error)
    }.disposed(by: disposeBag)
  }
  
  /// Hero Settings
  private func heroConfig(){
    hero.modalAnimationType = .selectBy(presenting: .pageIn(direction: .left), dismissing: .pageOut(direction: .right))
    emailField.hero.modifiers = [.translate(y:150)]
    passwordField.hero.modifiers = [.translate(y: 150)]
    loginButton.hero.modifiers = [.translate(y: 150)]
    dismissButton.hero.modifiers = [.translate(y: 150)]
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      zipImageView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalToSuperview().inset(100)
        make.height.equalTo(150)
        make.width.equalTo(150)
      }
      
      emailField.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.width.equalToSuperview().dividedBy(1.5)
      }
      
      passwordField.snp.makeConstraints { (make) in
        make.width.centerX.equalTo(emailField)
        make.top.equalTo(emailField.snp.bottom).offset(20)
      }
      
      loginButton.snp.makeConstraints { (make) in
        make.width.centerX.equalTo(passwordField)
        make.top.equalTo(passwordField.snp.bottom).offset(100)
      }
      
      dismissButton.snp.makeConstraints { (make) in
        make.width.centerX.equalTo(loginButton)
        make.top.equalTo(loginButton.snp.bottom).offset(40)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
