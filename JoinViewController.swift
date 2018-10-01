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
import Validator


#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class JoinViewController: UIViewController{

  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
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
    return field
  }()
  
  private lazy var passwordConfirmField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.errorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.lineColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.placeholderFont = .AppleSDGothicNeoMedium(size: 16)
    field.titleFont = .AppleSDGothicNeoMedium(size: 16)
    field.font = .AppleSDGothicNeoMedium(size: 16)
    field.lineErrorColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
    field.selectedLineColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    field.selectedTitleColor = .black
    field.placeholder = "비밀번호확인"
    field.placeholderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    field.isSecureTextEntry = true
    field.returnKeyType = .done
    field.keyboardType = .asciiCapable
    return field
  }()
  
//  private let signUpButton: UIButton = {
//    let button = UIButton()
//    button.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
//    button.setTitle("회원가입", for: .normal)
//    return button
//  }()
  
  private let signUpButton: LGButton = {
    let button = LGButton()
    button.titleString = "회원가입"
    button.titleColor = .white
    button.titleFontName = "AppleSDGothicNeo-Medium"
    button.titleFontSize = 17
    button.bgColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    button.loadingString = "가입중.."
    return button
  }()

  let joinView = JoinView()
  
  lazy var viewModel = JoinViewModel(email: emailField.rx.text.orEmpty,
                                     password: passwordField.rx.text.orEmpty,
                                     passwordConfirm: passwordConfirmField.rx.text.orEmpty,
                                     tap: signUpButton.rx.tapGesture().when(.ended).do(onNext: {[weak self] (_) in
                                      self?.signUpButton.isLoading = true
                                     }))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    view.hero.id = "loginToDefaultLogin"
    hero.isEnabled = true
    view.addSubview(logoImageView)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(passwordConfirmField)
    view.addSubview(signUpButton)
    logoImageView.addSubview(commaImageView)
    logoImageView.addSubview(commaImageView2)
    self.navigationController?.navigationBar.topItem?.title = String()
    view.setNeedsUpdateConstraints()
    behavior()

//    joinView.joinButton
//      .rx
//      .controlEvent(.touchUpInside)
//      .bind(onNext: signUp)
//      .disposed(by: disposeBag)
//
//    joinView.backButton.rx.controlEvent(.touchUpInside)
//      .subscribe { [weak self](event) in
//        self?.presentingViewController?.dismiss(animated: true, completion: nil)
//      }.disposed(by: disposeBag)
//
//    view.hero.id = String(describing: JoinViewController.self)
//    hero.isEnabled = true
    hero.modalAnimationType = .selectBy(presenting: .push(direction: .up), dismissing: .pull(direction: .down))
  }
  
  private func behavior(){
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
    
    viewModel.emailValid
      .subscribeNext(weak: self) { (retainSelf) -> (Bool) -> Void in
        return {result in
          retainSelf.emailField.errorMessage = result ? nil : "이메일형식이 아닙니다!"
        }
      }.disposed(by: disposeBag)
    
    viewModel.passwordValid
      .subscribeNext(weak: self) { (retainSelf) -> (Bool) -> Void in
        return {result in
          retainSelf.passwordField.errorMessage = result ? nil : "패스워드는 6자에서 20자 사이입니다."
        }
      }.disposed(by: disposeBag)
    
    
    viewModel.passwordConfirmValid
      .subscribeNext(weak: self) { (retainSelf) -> (Bool) -> Void in
        return {result in
          retainSelf.passwordConfirmField.errorMessage = result ? nil : "비밀번호가 일치하지 않습니다."
        }
      }.disposed(by: disposeBag)
    
    viewModel
      .isButtonEnable
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return { result in
          weakSelf.signUpButton.bgColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
          weakSelf.signUpButton.isEnabled = result
        }
    }.disposed(by: disposeBag)
    
    viewModel
      .taped
      .subscribe(weak: self) { (weakSelf) -> (Event<ResultModel<TokenModel>>) -> Void in
        return { event in
          switch event{
          case .next(let element):
            tokenObserver.onNext(element.result?.token ?? String())
          case .error(let error):
            guard let err = error as? MoyaError else {return}
            err.GalMalErrorHandler()
          case .completed:
            log.info("completed")
          }
          weakSelf.signUpButton.isLoading = false
        }
    }.disposed(by: disposeBag)
    
    
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  private func logoHidden(_ hidden: Bool){
    logoImageView.alpha = hidden ? 0 : 1
    commaImageView.alpha = hidden ? 0 : 1
    commaImageView2.alpha = hidden ? 0 : 1
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
        make.top.equalTo(logoImageView.snp.bottom).offset(90)
        make.left.right.equalToSuperview().inset(42)
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
  
//  private func signUp(){
//
//    let model = JoinModel(email: self.joinView.emailField.text ?? String(),
//                          password: self.joinView.passwordField.text ?? String())
//
//    provider.request(.signUp(model: model))
//      .map(ResultModel<TokenModel>.self)
//      .subscribe(onSuccess: {[weak self] (result) in
//        guard let `self` = self else {return}
//
//        if result.success{
//          self.dismiss(animated: true, completion: {
//            tokenObserver.onNext(result.result?.token ?? String())
//          })
//        }else{
//          JDStatusBarNotification.show(withStatus: result.error?.details ?? "가입 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
//        }
//      }, onError: { (error) in
//        JDStatusBarNotification.show(withStatus: "가입 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
//      })
//      .disposed(by: self.disposeBag)
//  }



