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
import FBSDKLoginKit

class LoginView: UIView{
  
  let zipImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Rectangle 6"))
    return imageView
  }()
  
  let kakaoButton: KOLoginButton = {
    let button = KOLoginButton()
    button.setTitle("카카오톡으로 갈래?", for: .normal)
    button.titleLabel?.font = UIFont.NotoSansKRMedium(size: 15)
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    return button
  }()
  
  lazy var emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "E-mail"
    field.placeholderColor = .black
    field.lineColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    field.keyboardType = .emailAddress
    field.returnKeyType = .done
    field.hero.id = "emailField"
    return field
  }()
  
  lazy var passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "Password"
    field.placeholderColor = .black
    field.lineColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    field.returnKeyType = .done
    field.isSecureTextEntry = true
    field.hero.id = "passwordField"
    return field
  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인하러 갈래?", for: .normal)
    button.titleLabel?.font = UIFont.NotoSansKRMedium(size: 15)
    button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    button.layer.cornerRadius = 5
    button.isEnabled = false
    return button
  }()
  
  let faceBookButton: UIButton = {
    let button = UIButton()
    button.setTitle("페이스북으로 갈래?", for: .normal)
    button.titleLabel?.font = UIFont.NotoSansKRMedium(size: 15)
    button.layer.cornerRadius = 5
    button.backgroundColor = #colorLiteral(red: 0.2034977426, green: 0.3029115768, blue: 1, alpha: 1)
    return button
  }()
  
  var constaint: Constraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    addSubview(kakaoButton)
    addSubview(zipImageView)
    addSubview(emailField)
    addSubview(passwordField)
    addSubview(loginButton)
    addSubview(faceBookButton)
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
      make.top.equalTo(passwordField.snp.bottom).offset(20)
      make.height.equalTo(40)
      make.width.equalTo(passwordField)
      make.centerX.equalToSuperview()
    }
    
    kakaoButton.snp.makeConstraints { (make) in
      make.top.equalTo(loginButton.snp.bottom).offset(20)
      make.height.equalTo(40)
      make.width.equalTo(loginButton)
      make.centerX.equalTo(loginButton)
    }
    
    faceBookButton.snp.makeConstraints { (make) in
      make.top.equalTo(kakaoButton.snp.bottom).offset(20)
      make.height.equalTo(40)
      make.width.equalTo(loginButton)
      make.centerX.equalTo(loginButton)
    }
  }
}
