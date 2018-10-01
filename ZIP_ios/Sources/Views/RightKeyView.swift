//
//  RightKeyView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


class RightKeyView: UIView {
  
  let imageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "icons8-key"))
    return imageView
  }()
  
  let countLabel: UILabel = {
    let label = UILabel()
    label.text = "33"
    label.font = UIFont.NotoSansKRMedium(size: 14)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    addSubview(countLabel)
    imageView.snp.makeConstraints { (make) in
      make.left.top.bottom.equalToSuperview()
      make.width.equalTo(self.snp.height)
    }
    countLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(imageView)
      make.left.equalTo(imageView.snp.right)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
