//
//  MyPageCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class MyPageCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoSemiBold(size: 22)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(48)
        make.centerY.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
