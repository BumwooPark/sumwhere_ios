//
//  DefaultLoginViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 16..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Hero
import RxSwift
import RxCocoa
import Moya
import SnapKit
import LGButton
import RxKeyboard
import Reachability
import TTTAttributedLabel
import SkyFloatingLabelTextField

final class DefaultLoginViewController: UIViewController{
  
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  private var keyboardDisposeBag = DisposeBag()

  var constraint: Constraint?
  
  var viewModel: DefaultLoginViewModel!
  
  private let secretButton: UIButton = {
    let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 26, height: 22)))
    button.setImage(#imageLiteral(resourceName: "textfieldsecret.png") , for: .normal)
    button.setImage(#imageLiteral(resourceName: "textfieldusesecret.png"), for: .selected)
    button.isSelected = true
    return button
  }()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "logoTypoBlack.png"))
    imageView.hero.id = "logoImageView"
    return imageView
  }()
  
  private let emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.errorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.placeholderFont = .AppleSDGothicNeoMedium(size: 16)
    field.titleFont = .AppleSDGothicNeoMedium(size: 16)
    field.font = .AppleSDGothicNeoMedium(size: 16)
    field.lineColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.lineErrorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.selectedLineColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    field.selectedTitleColor = .black
    field.placeholder = "이메일 주소"
    field.placeholderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.keyboardType = .emailAddress
    field.returnKeyType = .done
    field.hero.id = "email"
    return field
  }()
  
  private lazy var passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.errorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.lineColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.placeholderFont = .AppleSDGothicNeoMedium(size: 16)
    field.titleFont = .AppleSDGothicNeoMedium(size: 16)
    field.font = .AppleSDGothicNeoMedium(size: 16)
    field.lineErrorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.selectedLineColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    field.selectedTitleColor = .black
    field.placeholder = "비밀번호"
    field.placeholderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.isSecureTextEntry = true
    field.returnKeyType = .done
    field.keyboardType = .asciiCapable
    field.rightView = secretButton
    field.rightViewMode = .whileEditing
    field.hero.id = "password"
    return field
  }()
  
  private let loginButton: LGButton = {
    let button = LGButton()
    button.titleString = "로그인"
    button.titleColor = .white
    button.titleFontName = "AppleSDGothicNeo-Medium"
    button.titleFontSize = 17
    button.bgColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    button.layer.cornerRadius = 10
    button.hero.id = "button"
    return button
  }()
  
  private let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  private let findSecretButton: UIButton = {
    let button = UIButton()
    button.setTitle("비밀번호 찾기", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1), for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 13)
    return button
  }()
  
  private let signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle("회원가입", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.2862745098, green: 0.2862745098, blue: 0.2862745098, alpha: 1), for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 13)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    view.hero.id = "loginToDefaultLogin"
    hero.isEnabled = true
    view.addSubview(logoImageView)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(loginButton)
    view.addSubview(dividLine)
    view.addSubview(findSecretButton)
    view.addSubview(signUpButton)
    
    self.navigationController?.navigationBar.topItem?.title = String()
    
    let loginAction = loginButton
      .rx
      .tapGesture()
      .when(.ended)
      .do(onNext: {[weak self] (_) in
        self?.loginButton.isLoading = true
      }).share()
    
    viewModel = DefaultLoginViewModel(email: emailField.rx.text.orEmpty,
                                      password: passwordField.rx.text.orEmpty,
                                      tap: loginAction)
    
    
    findSecretButton
      .rx
      .tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.navigationController?.pushViewController(SearchPasswordViewController(), animated: true)
        }
      }.disposed(by: disposeBag)
    
    
    behavior()
    heroConfig()
    
    view.setNeedsUpdateConstraints()
    hideKeyboardWhenTappedAround()
  }
  
  private func behavior(){
    
    viewModel
      .API
      .do(onNext: {[weak self] _ in self?.loginButton.isLoading = false})
      .errors()
      .map{($0 as? MoyaError)?.response}
      .unwrap()
      .map(ResultModel<Bool>.self)
      .map{$0.error?.code}
      .unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {code in
          if code == 20001{
            weakSelf.emailField.errorMessage = "가입이 되어있지 않습니다."
            weakSelf.passwordField.errorMessage = String()
          }else if code == 20002{
            weakSelf.emailField.errorMessage = String()
            weakSelf.passwordField.errorMessage = "비밀번호가 틀립니다."
          }
        }
    }.disposed(by: disposeBag)
    
    Observable
      .merge([emailField.rx.text.orEmpty.asObservable(),passwordField.rx.text.orEmpty.asObservable()])
      .subscribeNext(weak: self) {(weakSelf) -> (String) -> Void in
        return { _ in
          weakSelf.emailField.errorMessage = String()
          weakSelf.passwordField.errorMessage = String()
        }
      }.disposed(by: disposeBag)
    
    viewModel
      .API
      .do(onNext: {[weak self] _ in self?.loginButton.isLoading = false})
      .elements()
      .map{$0.token}
      .unwrap()
      .bind(to: tokenObserver)
      .disposed(by: disposeBag)
    
    secretButton
      .rx
      .tap
      .map{!self.secretButton.isSelected}
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return { result in
          weakSelf.passwordField.isSecureTextEntry = result
          weakSelf.secretButton.isSelected = result
        }
    }.disposed(by: disposeBag)
    
    viewModel
      .isEnable
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return { result in
          weakSelf.loginButton.bgColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
          weakSelf.loginButton.isEnabled = result
        }
    }.disposed(by: disposeBag)
    
    signUpButton
      .rx
      .tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
      return { _ in
        weakSelf.navigationController?.pushViewController(JoinViewController(), animated: true)
      }
    }.disposed(by: disposeBag)
  }
  
  private func logoHidden(_ hidden: Bool){
    logoImageView.alpha = hidden ? 0 : 1
    dividLine.isHidden = hidden
    signUpButton.isHidden = hidden
    findSecretButton.isHidden = hidden
  }
  
  /// Hero Settings
  private func heroConfig(){
    hero.modalAnimationType = .selectBy(presenting: .pageIn(direction: .left), dismissing: .pageOut(direction: .right))
    emailField.hero.modifiers = [.translate(y:150)]
    passwordField.hero.modifiers = [.translate(y: 150)]
    loginButton.hero.modifiers = [.translate(y: 150)]
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      logoImageView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-100)
      }
      
      emailField.snp.makeConstraints { (make) in
        constraint = make.top.equalTo(logoImageView.snp.bottom).offset(90).constraint
        make.left.right.equalToSuperview().inset(42)
      }
      
      passwordField.snp.makeConstraints { (make) in
        make.width.centerX.equalTo(emailField)
        make.top.equalTo(emailField.snp.bottom).offset(20)
      }
      
      loginButton.snp.makeConstraints { (make) in
        make.left.right.equalTo(passwordField)
        make.top.equalTo(passwordField.snp.bottom).offset(37)
        make.height.equalTo(51)
      }
      
      dividLine.snp.makeConstraints { (make) in
        make.top.equalTo(loginButton.snp.bottom).offset(31)
        make.centerX.equalToSuperview()
        make.height.equalTo(signUpButton)
        make.width.equalTo(1)
      }
      
      signUpButton.snp.makeConstraints { (make) in
        make.left.equalTo(dividLine.snp.right).offset(10)
        make.centerY.equalTo(dividLine)
      }
      
      findSecretButton.snp.makeConstraints { (make) in
        make.right.equalTo(dividLine.snp.left).offset(-10)
        make.centerY.equalTo(dividLine)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
  func rxKeyBoardSetting(){
    RxKeyboard.instance
      .visibleHeight
      .drive(onNext: {[unowned self] (float) in
        self.emailField.snp.remakeConstraints({ (make) in
          make.top.equalTo(self.logoImageView.snp.bottom).offset((90 - float))
          make.left.right.equalToSuperview().inset(42)
        })
        if float == 0 {
          self.logoHidden(false)
        }else{
          self.logoHidden(true)
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
          self.view.setNeedsLayout()
          self.view.layoutIfNeeded()
        }, completion: nil)
      }).disposed(by: keyboardDisposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    rxKeyBoardSetting()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    keyboardDisposeBag = DisposeBag()
    
  }
}

extension DefaultLoginViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    present(JoinViewController(), animated: true, completion: nil)
  }
}
