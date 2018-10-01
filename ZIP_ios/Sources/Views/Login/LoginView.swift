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
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "group7"), for: .normal)
    return button
  }()
  
  let faceBookButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "facebookButton.png"), for: .normal)
    return button
  }()
  
  let kakaoButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "facebookButton.png"), for: .normal)
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [faceBookStackView,kakaoStackView,loginStackView])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    return stackView
  }()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "group23"))
    imageView.hero.id = "logoImageView"
    return imageView
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
  
  private lazy var loginStackView: UIStackView = {
    let label = UILabel()
    label.text = "갈래말래"
    label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
    label.textColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
    let stackView = UIStackView(arrangedSubviews: [loginButton,label])
    stackView.spacing = 10
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    return stackView
  }()
  
  private lazy var kakaoStackView: UIStackView = {
    let label = UILabel()
    label.text = "카카오톡"
    label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
    label.textColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
    let stackView = UIStackView(arrangedSubviews: [kakaoButton,label])
    stackView.spacing = 10
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    return stackView
  }()
  
  private lazy var faceBookStackView: UIStackView = {
    let label = UILabel()
    label.text = "페이스북"
    label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
    label.textColor = #colorLiteral(red: 0.2156862745, green: 0.3294117647, blue: 0.4901960784, alpha: 1)
    let stackView = UIStackView(arrangedSubviews: [faceBookButton,label])
    stackView.spacing = 10
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    return stackView
  }()
  
  let joinLabel: TTTAttributedLabel = {
    let label = TTTAttributedLabel(frame: .zero)
    let attstring = NSAttributedString(string: "아직 회원이 아니신가요?  회원가입하기",
                                       attributes: [NSAttributedStringKey.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 14)])
    label.attributedText = attstring
    label.textColor = .black
    let range = NSRange(location: 15, length: 6)
    label.addLink(to: URL(fileURLWithPath: ""), with: range)
    label.sizeToFit()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    hero.isEnabled = true 
    backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    addSubview(stackView)
    addSubview(logoImageView)
    addSubview(joinLabel)
    logoImageView.addSubview(commaImageView)
    logoImageView.addSubview(commaImageView2)
    
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
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
    
    stackView.snp.makeConstraints { (make) in
      make.right.left.equalToSuperview().inset(50)
      make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(130)
      make.height.equalTo(150)
    }
    
    joinLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(50)
      make.centerX.equalToSuperview()
    }
  }
}
