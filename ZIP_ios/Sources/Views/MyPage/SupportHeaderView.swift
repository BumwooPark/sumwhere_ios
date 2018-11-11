//
//  SupportHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class SupportHeaderView: UICollectionReusableView{
  var didUpdateConstraint = false
  let title: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 16)
    label.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(title)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      title.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(28)
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
