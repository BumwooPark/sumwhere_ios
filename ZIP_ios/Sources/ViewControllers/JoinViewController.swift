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


#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

class JoinViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let provider = MoyaProvider<ZIP>().rx
  let smsVC = SMSCertViewController()
  
  let backImageView: SpringImageView = {
    let imageView = SpringImageView(image: #imageLiteral(resourceName: "bare-1985858_1920"))
    imageView.contentMode = .scaleAspectFill
    imageView.addBlurEffect()
    return imageView
  }()
  
  let emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "이메일 주소"
    field.disabledColor = .blue
    field.placeholderColor = .black
    field.lineColor = .black
    field.selectedLineColor = .white
    field.selectedTitleColor = .blue
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.textColor = .white
    field.keyboardType = .emailAddress
    return field
  }()
  
  let nicknameField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "닉네임"
    field.placeholderColor = .black
    field.lineColor = .black
    field.selectedLineColor = .white
    field.selectedTitleColor = .blue
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.textColor = .white
    return field
  }()
  
  let passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "비밀번호"
    field.isSecureTextEntry = true
    field.placeholderColor = .black
    field.lineColor = .black
    field.selectedLineColor = .white
    field.selectedTitleColor = .blue
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.textColor = .white
    return field
  }()
  
  let passwordConfField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "비밀번호 확인"
    field.isSecureTextEntry = true
    field.lineColor = .black
    field.placeholderColor = .black
    field.selectedLineColor = .white
    field.selectedTitleColor = .blue
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.textColor = .white
    return field
  }()
  
  let joinButton: LGButton = {
    let button = LGButton()
    button.titleString = "가입하기"
    button.titleFontSize = 15
    button.titleColor = .white
    button.fullyRoundedCorners = true
    button.gradientStartColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    button.gradientEndColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    button.gradientHorizontal = true
    button.shadowColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    return button
  }()
  
  let backButton: LGButton = {
    let button = LGButton()
    button.titleString = "뒤로가기"
    button.titleColor = .white
    button.fullyRoundedCorners = true
    button.titleFontSize = 14
    return button
  }()
  
  lazy var infoAgreeLabel: TTTAttributedLabel = {
    let label = TTTAttributedLabel(frame: .zero)
    let string: NSString = "가입하기 버튼을 누름으로써, 개인정보 보호 정책과 서비스 이용약관을 \n읽고 동의했음으로 간주됩니다."
    let range = string.range(of: "개인정보 보호 정책")
    let url = URL(string: "http://bumwooPark.github.io")
    let attribute = NSAttributedString(string: string as String)
    label.attributedText = attribute
    label.delegate = self
    label.addLink(to: url!, with: range)
    label.sizeToFit()
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.isHeroEnabled = true 
    self.view.backgroundColor = .clear
    self.view.addSubview(backImageView)
    self.view.addSubview(emailField)
    self.view.addSubview(nicknameField)
    self.view.addSubview(passwordField)
    self.view.addSubview(passwordConfField)
    self.view.addSubview(joinButton)
    self.view.addSubview(backButton)
    self.view.addSubview(infoAgreeLabel)
    
    emailField.heroID = "emailField"
    passwordField.heroID = "passwordField"
    backImageView.heroID = "backImageView"
    
    addConstraint()
    
    let emailVaild = emailField.rx.text
      .orEmpty
      .map {!re.findall("^[a-z0-9_+.-]+@([a-z0-9-]+\\.)+[a-z0-9]{2,4}$", $0).isEmpty}
      .share(replay: 1)
    
    let nicknameVaild = nicknameField.rx.text
      .orEmpty
      .map{ $0.length > 1}
      .share(replay: 1)
    
    let passwordVaild = passwordField.rx.text
      .orEmpty
      .map{!re.findall("^[A-Za-z0-9]{6,20}$", $0).isEmpty}
      .share(replay: 1)
    
    let passwordConfVaild = passwordConfField.rx.text
      .map{[weak self] in
        self?.passwordField.text == $0
      }.share(replay: 1)
    
    Observable<Bool>.combineLatest(emailVaild, nicknameVaild, passwordVaild, passwordConfVaild)
    {return $0 && $1 && $2 && $3}
      .bind(to: joinButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    //TODO: 해야됨
    joinButton.rx.controlEvent(.touchUpInside)
      .bind(onNext: api)
      .disposed(by: disposeBag)
    
    backButton.rx.controlEvent(.touchUpInside)
      .subscribe { [weak self](event) in
        self?.presentingViewController?.dismiss(animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    self.view.heroID = "joinview"
    isHeroEnabled = true
    self.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
  }
  
  private func api(){
    
    self.joinButton.showLoading()
    let fcmtoken = Messaging.messaging().fcmToken ?? ""
    provider
      .request(.join(email: emailField.text!, kakao_id: ""
        , password: passwordField.text!
        , nickname: nicknameField.text!
        , fcm_token: fcmtoken, type: "default")
      )
      .asObservable()
      .map{(JSON(data: $0.data)["result"]["errorType"].string
        ,JSON(data: $0.data)["result"]["message"].string)}
      .subscribe {[weak self] data in
        guard let tuple = data.element else {return}
        self?.joinButton.hideLoading()
        if tuple.0 == "email"{
          self?.emailField.errorMessage = tuple.1
        }else if tuple.0 == "nickname"{
          self?.nicknameField.errorMessage = tuple.1
        }else{
          self?.presentView(email: self?.emailField.text)
        }
      }.disposed(by: self.disposeBag)
  }
  
  private func presentView(email: String?){
    smsVC.userEmail = email
    self.present(smsVC, animated: true, completion: nil)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.emailField.errorMessage = ""
    self.nicknameField.errorMessage = ""
    self.view.endEditing(true)
  }
  
  private func addConstraint(){
    
    backImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    emailField.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(100)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().dividedBy(1.5)
    }
    
    nicknameField.snp.makeConstraints { (make) in
      make.top.equalTo(emailField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(emailField)
    }
    
    passwordField.snp.makeConstraints { (make) in
      make.top.equalTo(nicknameField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(nicknameField)
    }
    
    passwordConfField.snp.makeConstraints { (make) in
      make.top.equalTo(passwordField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(passwordField)
    }
    
    joinButton.snp.makeConstraints { (make) in
      make.top.equalTo(passwordConfField.snp.bottom).offset(100)
      make.centerX.equalToSuperview()
      make.width.equalTo(passwordConfField)
      make.height.equalTo(40)
    }
    
    backButton.snp.makeConstraints { (make) in
      make.top.equalTo(joinButton.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(joinButton)
      make.height.equalTo(joinButton)
    }
    
    infoAgreeLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
  }
}

extension JoinViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    print("click")
  }
}


