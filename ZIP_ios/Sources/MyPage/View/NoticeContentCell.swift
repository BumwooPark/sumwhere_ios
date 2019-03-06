//
//  NoticeContentCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

class NoticeContentCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  var item: NoticeSectionModel?{
    didSet{
      contentLabel.text = item?.data.text
    }
  }
  
  private let contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.AppleSDGothicNeoSemiBold(size: 12)
    label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(contentLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      contentLabel.snp.makeConstraints { (make) in
        make.left.top.bottom.right.equalToSuperview().inset(27)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
