//
//  SupportCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class SupportCell: UICollectionViewCell{
  var didUpdateConstraint = false
  private let underLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 18)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(underLine)
    contentView.addSubview(titleLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint {
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(32)
        make.centerY.equalToSuperview()
      }
      underLine.snp.makeConstraints { (make) in
        make.bottom.equalToSuperview()
        make.left.right.equalToSuperview().inset(17)
        make.height.equalTo(2)
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
