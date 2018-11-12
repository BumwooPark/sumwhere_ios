//
//  MyPageHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class MyPageHeaderView: UICollectionReusableView{
  var userModel: UserModel?{
    didSet{
      idLabel.text = "\(userModel?.nickname ?? String())님"
      emailLabel.text = userModel?.email
      storeButton.setAttributedTitle(self.storeAttributeString(key: userModel?.point ?? 0), for: .normal)
    }
  }
  var didUpdateConstraint = false
  
  let idLabel: UILabel = {
    let label = UILabel()
    label.text = "슈퍼스타 tat님"
    label.font = .AppleSDGothicNeoBold(size: 22)
    return label
  }()
  
  let emailLabel: UILabel = {
    let label = UILabel()
    label.text = "qjadn0914@naver.com"
    label.font = .AppleSDGothicNeoMedium(size: 13)
    return label
  }()
  
  let profileImage: UIImageView = {
    let profile = UIImageView()
    profile.backgroundColor = .blue
    profile.layer.cornerRadius = 50
    profile.layer.masksToBounds = true
    return profile
  }()
  
  let storeButton: UIButton = {
    let button = UIButton()
    let attributedString = NSMutableAttributedString(string: "스토어\n3 개의 키가 남아있어요")
    
    attributedString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:"AppleSDGothicNeo-SemiBold", size:22.0)!, range:NSMakeRange(0,3))
    attributedString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:"AppleSDGothicNeo-SemiBold", size:12.0)!, range:NSMakeRange(4,13))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.black, range:NSMakeRange(0,4))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor(red:0.387, green:0.566, blue:0.916, alpha:1.0), range:NSMakeRange(4,1))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.black, range:NSMakeRange(5,12))
    button.setAttributedTitle(attributedString, for: .normal)
    button.setImage(#imageLiteral(resourceName: "mypageButton.png"), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 150)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
    button.titleLabel?.textAlignment = .left
    button.contentHorizontalAlignment = .leading
    button.semanticContentAttribute = .forceRightToLeft
    button.titleLabel?.numberOfLines = 0
    button.backgroundColor = .white
    button.layer.cornerRadius = 47
    button.layer.masksToBounds = true 
    return button
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    addSubview(idLabel)
    addSubview(profileImage)
    addSubview(emailLabel)
    addSubview(storeButton)
    setNeedsUpdateConstraints()
  }
  
  func storeAttributeString(key: Int) -> NSMutableAttributedString{
    let attributedString = NSMutableAttributedString(string: "스토어\n\(key) 개의 키가 남아있어요")
    
    attributedString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:"AppleSDGothicNeo-SemiBold", size:22.0)!, range:NSMakeRange(0,3))
    attributedString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:"AppleSDGothicNeo-SemiBold", size:12.0)!, range:NSMakeRange(4,13))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.black, range:NSMakeRange(0,4))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor(red:0.387, green:0.566, blue:0.916, alpha:1.0), range:NSMakeRange(4,1))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.black, range:NSMakeRange(5,12))
    return attributedString
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      idLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(48)
        make.top.equalToSuperview().inset(60)
      }
      
      emailLabel.snp.makeConstraints { (make) in
        make.top.equalTo(idLabel.snp.bottom).offset(5)
        make.left.equalTo(idLabel.snp.left).inset(10)
      }
      
      profileImage.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(26)
        make.top.equalToSuperview().inset(34)
        make.width.height.equalTo(100)
      }
      
      storeButton.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(21)
        make.height.equalTo(94)
        make.top.equalTo(profileImage.snp.bottom).offset(17)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
