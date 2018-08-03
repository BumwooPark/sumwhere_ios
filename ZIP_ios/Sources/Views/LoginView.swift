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
import TTTAttributedLabel

class LoginView: UIView{
  
  let logoImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
    imageView.hero.id = "logoImageView"
    return imageView
  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인하러 갈래?", for: .normal)
    button.titleLabel?.font = UIFont.BMJUA(size: 20)
    button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    button.layer.cornerRadius = 5
    return button
  }()
  
  let kakaoButton: UIButton = {
    let button = UIButton()
    button.setTitle("카카오톡으로 갈래?", for: .normal)
    button.titleLabel?.font = UIFont.BMJUA(size: 20)
    button.layer.cornerRadius = 5
    button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    return button
  }()
  
  let faceBookButton: UIButton = {
    let button = UIButton()
    button.setTitle("페이스북으로 갈래?", for: .normal)
    button.titleLabel?.font = UIFont.BMJUA(size: 20)
    button.layer.cornerRadius = 5
    button.backgroundColor = #colorLiteral(red: 0.2034977426, green: 0.3029115768, blue: 1, alpha: 1)
    return button
  }()
  
  let joinLabel: TTTAttributedLabel = {
    let label = TTTAttributedLabel(frame: .zero)
    let attstring = NSAttributedString(string: "아이디가 없으면 여기를 눌러!",
                                       attributes: [NSAttributedStringKey.font : UIFont.BMJUA(size: 20)])
    label.attributedText = attstring
    label.textColor = .black
    let range = NSRange(location: 9, length: 2)
    label.addLink(to: URL(fileURLWithPath: ""), with: range)
    return label
  }()
  
  
  var constaint: Constraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    hero.isEnabled = true 
    backgroundColor = .white
    addSubview(kakaoButton)
    addSubview(logoImageView)
    addSubview(loginButton)
    addSubview(faceBookButton)
    addSubview(joinLabel)
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
    logoImageView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(100)
      make.height.width.equalTo(110)
    }
    
    loginButton.snp.makeConstraints { (make) in
      make.centerY.centerX.equalToSuperview()
      make.height.equalTo(40)
      make.width.equalToSuperview().dividedBy(1.5)
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
    
    joinLabel.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(40)
      make.centerX.equalTo(faceBookButton)
    }
    joinLabel.sizeToFit()
  }
}
