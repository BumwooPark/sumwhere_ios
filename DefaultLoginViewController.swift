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
import RxOptional
import RxKeyboard
import Reachability
import TTTAttributedLabel
import JDStatusBarNotification
import SkyFloatingLabelTextField

final class DefaultLoginViewController: UIViewController{
  
  
  let reachability = Reachability()!
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()

  var constraint: Constraint?
  
  var viewModel: DefaultLoginViewModel!
  
  private let secretButton: UIButton = {
    let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 26, height: 22)))
    button.setImage(#imageLiteral(resourceName: "textfieldsecret.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "textfieldsecret2.png"), for: .selected)
    button.isSelected = true
    return button
  }()
  
  private let commaImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "invalidName"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let commaImageView2: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "invalidName2"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "group23"))
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
    return field
  }()
  
  private let loginButton: LGButton = {
    let button = LGButton()
    button.titleString = "회원가입"
    button.titleColor = .white
    button.titleFontName = "AppleSDGothicNeo-Medium"
    button.titleFontSize = 17
    button.bgColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    button.loadingString = "가입중.."
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
    logoImageView.addSubview(commaImageView)
    logoImageView.addSubview(commaImageView2)
    self.navigationController?.navigationBar.topItem?.title = String()
    
    viewModel = DefaultLoginViewModel(email: emailField.rx.text.orEmpty,
                                      password: passwordField.rx.text.orEmpty,
                                      tap: loginButton.rx.tapGesture().when(.ended).do(onNext: {[weak self] (_) in
                                        self?.loginButton.isLoading = true
                                      }))
    behavior()
    heroConfig()
    reachText()
    view.setNeedsUpdateConstraints()
    
    NotificationCenter.default.rx
      .notification(.reachabilityChanged, object: reachability)
      .subscribe(onNext: { (noti) in
        log.info(noti)
      }).disposed(by: disposeBag)
  }
  
  func reachText(){
    reachability.whenReachable = { reachability in
      if reachability.connection == .wifi {
        print("Reachable via WiFi")
      } else {
        print("Reachable via Cellular")
      }
    }
    reachability.whenUnreachable = { _ in
      print("Not reachable")
    }
    
    do {
      try reachability.startNotifier()
    } catch {
      print("Unable to start notifier")
    }
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
      }).disposed(by: disposeBag)
    
    secretButton.rx.tap
      .map{!self.secretButton.isSelected}
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return { result in
          weakSelf.passwordField.isSecureTextEntry = result
          weakSelf.secretButton.isSelected = result
        }
    }.disposed(by: disposeBag)
    
    viewModel.isEnable
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return { result in
          weakSelf.loginButton.bgColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
          weakSelf.loginButton.isEnabled = result
        }
    }.disposed(by: disposeBag)
  }
  
  private func logoHidden(_ hidden: Bool){
    logoImageView.alpha = hidden ? 0 : 1
    commaImageView.alpha = hidden ? 0 : 1
    commaImageView2.alpha = hidden ? 0 : 1
  }

  /// API Login
  private func login(){
    
    viewModel.tempResult
      .subscribe(onNext: { (model) in
        log.info(model)
        tokenObserver.onNext(model.result?.token ?? String())
      }, onError: { (error) in
        guard let err = error as? MoyaError else {return}
        err.GalMalErrorHandler()
      }).disposed(by: disposeBag)
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
        make.centerY.equalToSuperview().inset(-100)
        make.width.equalTo(184)
        make.height.equalTo(58)
      }
      
      commaImageView.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.height.width.equalTo(10)
      }
      
      commaImageView2.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(-15)
        make.centerY.equalToSuperview()
        make.height.width.equalTo(10)
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
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension DefaultLoginViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    present(JoinViewController(), animated: true, completion: nil)
  }
}
