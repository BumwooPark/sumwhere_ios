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
import TTTAttributedLabel
import Firebase


#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class JoinViewController: UIViewController{

  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  
  private let floatingTextFieldSetting = { (field: SkyFloatingLabelTextField) in
    field.errorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.lineColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.placeholderFont = .AppleSDGothicNeoMedium(size: 16)
    field.titleFont = .AppleSDGothicNeoMedium(size: 16)
    field.font = .AppleSDGothicNeoMedium(size: 16)
    field.lineErrorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.selectedLineColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    field.placeholderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.selectedTitleColor = .black
    field.returnKeyType = .done
  }

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "회원가입"
    label.font = .KoreanSWGI1R(size: 23)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    label.hero.id = "logoImageView"
    return label
  }()
  
  private lazy var emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    self.floatingTextFieldSetting(field)
    field.placeholder = "이메일 주소"
    field.placeholderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.keyboardType = .emailAddress
    field.hero.id = "email"
    return field
  }()
  
  private lazy var passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    self.floatingTextFieldSetting(field)
    field.placeholder = "비밀번호"
    field.isSecureTextEntry = true
    field.keyboardType = .asciiCapable
    field.hero.id = "password"
    return field
  }()
  
  private lazy var passwordConfirmField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    self.floatingTextFieldSetting(field)
    field.placeholder = "비밀번호확인"
    field.placeholderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.isSecureTextEntry = true
    field.returnKeyType = .done
    field.keyboardType = .asciiCapable
    return field
  }()
  
  private let signUpButton: LGButton = {
    let button = LGButton()
    button.titleString = "회원가입"
    button.titleColor = .white
    button.titleFontName = "AppleSDGothicNeo-Medium"
    button.titleFontSize = 17
    button.bgColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    button.isEnabled = false
    button.hero.id = "button"
    return button
  }()
  
  lazy var viewModel: JoinType = JoinViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    view.hero.id = "loginToDefaultLogin"
    hero.isEnabled = true
    view.addSubview(titleLabel)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(passwordConfirmField)
    view.addSubview(signUpButton)
    
    self.navigationController?.navigationBar.topItem?.title = String()
    view.setNeedsUpdateConstraints()
    bind()
    hero.modalAnimationType = .selectBy(presenting: .push(direction: .up), dismissing: .pull(direction: .down))
  }
  
  private func bind(){
    
    Observable.merge([
      emailField.rx.text.orEmpty
      .map{DataType.email($0)}
      ,passwordField.rx.text.orEmpty
        .map{DataType.password1($0)}
      ,passwordConfirmField.rx.text.orEmpty
        .map{DataType.password2($0)}])
      .bind(onNext: viewModel.input.assign)
      .disposed(by: disposeBag)
    
    viewModel.output.isCanSubmit
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return {result in
          weakSelf.signUpButton.bgColor = result ? #colorLiteral(red: 0.3371393681, green: 0.4714460969, blue: 0.8907750249, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
          weakSelf.signUpButton.isEnabled = result
        }
    }.disposed(by: disposeBag)
    
    signUpButton.rx.tapGesture()
      .when(.ended)
      .map{_ in return ()}
      .bind(onNext: viewModel.input.submit)
      .disposed(by: disposeBag)
    
    viewModel.output.submitResult
      .elements()
      .subscribeNext(weak: self) { (weakSelf) -> (TokenModel) -> Void in
        return { data in
          log.info(data)
        }
      }.disposed(by: disposeBag)
    
    viewModel.output.submitResult
      .errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {error in
          log.error(error)
        }
      }.disposed(by: disposeBag)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
        make.left.equalToSuperview().inset(37)
      }
      
      emailField.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(53)
        make.left.right.equalToSuperview().inset(30)
      }
      
      passwordField.snp.makeConstraints { (make) in
        make.width.centerX.equalTo(emailField)
        make.top.equalTo(emailField.snp.bottom).offset(20)
      }
      
      passwordConfirmField.snp.makeConstraints { (make) in
        make.width.centerX.equalTo(passwordField)
        make.top.equalTo(passwordField.snp.bottom).offset(20)
      }
      
      signUpButton.snp.makeConstraints { (make) in
        make.left.right.equalTo(passwordConfirmField)
        make.top.equalTo(passwordConfirmField.snp.bottom).offset(37)
        make.height.equalTo(51)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
