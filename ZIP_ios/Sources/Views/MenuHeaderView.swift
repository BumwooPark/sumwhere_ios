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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(profileImage)
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !didUpdateConstraints{
      
      profileImage.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.width.equalToSuperview().dividedBy(2)
        make.height.equalTo(profileImage.snp.width)
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
