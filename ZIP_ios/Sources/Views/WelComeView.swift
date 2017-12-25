//
//  File.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import RxKeyboard
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField
import SnapKit

class WelComeView: UIView{

  let imageView: UIImageView = {
    let image = UIImageView(image: #imageLiteral(resourceName: "bare-1985858_1920"))
    image.contentMode = .scaleAspectFill
    image.alpha = 0.9
    image.heroID = "backImageView"
    return image
  }()
  
  let zipImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Rectangle 6"))
    return imageView
  }()
  
  let kakaoButton: KOLoginButton = {
    let button = KOLoginButton()
    button.setTitle("카카오톡으로 로그인", for: .normal)
    button.layer.cornerRadius = 10
    return button
  }()
  
  lazy var emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "E-mail"
    field.placeholderColor = .black
    field.lineColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    field.keyboardType = .emailAddress
    field.returnKeyType = .done
    field.heroID = "emailField"
    return field
  }()
  
  lazy var passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "Password"
    field.placeholderColor = .black
    field.lineColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    field.returnKeyType = .done
    field.isSecureTextEntry = true
    field.heroID = "passwordField"
    return field
  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    button.layer.cornerRadius = 10
    button.isEnabled = false
    return button
  }()
  
  let joinButton: UIButton = {
    let button = UIButton()
    button.setTitle("가입하기", for: .normal)
    button.layer.cornerRadius = 10
    button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    return button
  }()
  
  var constaint: Constraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    insertSubview(kakaoButton, aboveSubview: imageView)
    addSubview(zipImageView)
    addSubview(emailField)
    addSubview(passwordField)
    addSubview(loginButton)
    addSubview(joinButton)
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
    
    zipImageView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(100)
      make.height.equalTo(150)
      make.width.equalTo(150)
    }
    
    emailField.snp.makeConstraints {[weak self] (make) in
      make.centerX.equalToSuperview()
      self?.constaint = make.centerY.equalToSuperview().constraint
      make.height.equalTo(40)
      make.width.equalToSuperview().dividedBy(1.5)
    }
    
    passwordField.snp.makeConstraints { (make) in
      make.centerX.equalTo(emailField)
      make.width.equalTo(emailField)
      make.height.equalTo(emailField)
      make.top.equalTo(emailField).offset(60)
    }
    
    loginButton.snp.makeConstraints { (make) in
      make.top.equalTo(passwordField).offset(60)
      make.height.equalTo(passwordField)
      make.width.equalTo(passwordField)
      make.centerX.equalToSuperview()
    }
    
    joinButton.snp.makeConstraints { (make) in
      make.top.equalTo(loginButton).offset(60)
      make.height.equalTo(loginButton)
      make.width.equalTo(loginButton)
      make.centerX.equalToSuperview()
    }
    
    kakaoButton.snp.makeConstraints { (make) in
      make.top.equalTo(joinButton).offset(60)
      make.height.equalTo(40)
      make.width.equalTo(passwordField)
      make.centerX.equalToSuperview()
    }
  }
}
