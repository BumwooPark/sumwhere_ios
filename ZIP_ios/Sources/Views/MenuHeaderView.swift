//
//  MenuHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 15..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class MenuHeaderView: UIView {
  
  var didUpdateConstraints = false
  let profileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .blue
    return imageView
  }()
  
  let nicknameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.BMJUA(size: 20)
    label.text = "nickname"
    return label
  }()
  
  let keyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.BMJUA(size: 16)
    label.textColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    label.text = "50"
    return label
  }()
  
  let keyImage = UIImageView(image: #imageLiteral(resourceName: "menuCopy2"))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(profileImage)
    addSubview(nicknameLabel)
    addSubview(keyLabel)
    addSubview(keyImage)
    
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !didUpdateConstraints{
      
      profileImage.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(25)
        make.centerX.equalToSuperview()
        make.width.equalToSuperview().dividedBy(2)
        make.height.equalTo(profileImage.snp.width)
      }
      
      nicknameLabel.snp.makeConstraints { (make) in
        make.centerX.equalTo(profileImage).inset(5)
        make.top.equalTo(profileImage.snp.bottom).offset(15)
      }
      
      keyLabel.snp.makeConstraints { (make) in
        make.centerX.equalTo(profileImage).inset(5)
        make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
      }
      
      keyImage.snp.makeConstraints { (make) in
        make.centerY.equalTo(keyLabel)
        make.right.equalTo(keyLabel.snp.left).offset(-5)
        make.height.width.equalTo(20)
      }
      
      didUpdateConstraints = true
    }
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    profileImage.layer.cornerRadius = profileImage.frame.width/2
    profileImage.layer.masksToBounds = true
  }
}
