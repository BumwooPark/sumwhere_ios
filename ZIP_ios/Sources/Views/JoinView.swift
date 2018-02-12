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
import Pastel

class JoinView: UIView{
  
  let backImageView: PastelView = {
    let image = PastelView(frame: UIScreen.main.bounds)
    image.startPastelPoint = .bottomLeft
    image.endPastelPoint = .topRight
    image.animationDuration = 3.0
    image.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                     UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                     UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                     UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                     UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                     UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                     UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
    image.heroID = "backImageView"
    image.startAnimation()
    return image
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
    addSubview(backImageView)
    addSubview(emailField)
    addSubview(nicknameField)
    addSubview(passwordField)
    addSubview(passwordConfField)
    addSubview(joinButton)
    addSubview(backButton)
    addSubview(infoAgreeLabel)
    emailField.heroID = "emailField"
    passwordField.heroID = "passwordField"
    backImageView.heroID = "backImageView"
    
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
    
    backImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    emailField.snp.makeConstraints { (make) in
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(100)
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
      make.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(50)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
  }
}
