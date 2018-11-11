//
//  MyPageHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class MyPageHeaderView: UICollectionReusableView{
  
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
    button.setTitle("스토어\n3개의 키가 남아있어요", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.numberOfLines = 0
    button.backgroundColor = .white
    button.layer.cornerRadius = 47
    button.layer.masksToBounds = true 
    return button
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(idLabel)
    addSubview(profileImage)
    addSubview(emailLabel)
    addSubview(storeButton)
    setNeedsUpdateConstraints()
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
