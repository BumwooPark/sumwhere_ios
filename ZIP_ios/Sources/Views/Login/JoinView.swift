//
//  JoinView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 29..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import TTTAttributedLabel
import LGButton
import Spring


class JoinView: UIView{
  
  let emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "이메일 주소"
    field.disabledColor = .green
    field.placeholderColor = .lightGray
    field.lineColor = .black
    field.selectedLineColor = .blue
    field.selectedTitleColor = .green
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.textColor = .black
    field.keyboardType = .emailAddress
    return field
  }()
  
  let passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "비밀번호"
    field.isSecureTextEntry = true
    field.placeholderColor = .black
    field.lineColor = .black
    field.selectedLineColor = .black
    field.selectedTitleColor = .blue
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.textColor = .black
    field.keyboardType = .asciiCapableNumberPad
    return field
  }()
  
  let passwordConfField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "비밀번호 확인"
    field.isSecureTextEntry = true
    field.lineColor = .black
    field.placeholderColor = .black
    field.selectedLineColor = .black
    field.selectedTitleColor = .black
    field.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    field.textColor = .black
    field.keyboardType = .asciiCapableNumberPad
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
  
  let infoAgreeLabel: TTTAttributedLabel = {
    let label = TTTAttributedLabel(frame: .zero)
    let string: NSString = "가입하기 버튼을 누름으로써, 개인정보 보호 정책과 서비스 이용약관을 \n읽고 동의했음으로 간주됩니다."
    let range = string.range(of: "개인정보 보호 정책")
    let url = URL(string: "http://bumwooPark.github.io")
    let attribute = NSAttributedString(string: string as String)
    label.attributedText = attribute
    label.addLink(to: url!, with: range)
    label.sizeToFit()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    addSubview(emailField)
    addSubview(passwordField)
    addSubview(passwordConfField)
    addSubview(joinButton)
    addSubview(backButton)
    addSubview(infoAgreeLabel)
    emailField.hero.id = "emailField"
    passwordField.hero.id = "passwordField"
    
    
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){

    emailField.snp.makeConstraints { (make) in
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(100)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().dividedBy(1.5)
    }
    
    passwordField.snp.makeConstraints { (make) in
      make.top.equalTo(emailField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(emailField)
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
      make.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(50)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
  }
}
