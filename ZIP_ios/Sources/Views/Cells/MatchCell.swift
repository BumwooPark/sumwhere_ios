//
//  MatchCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 31..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import LGButton

class MatchCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  var item: MatchTypeModel?{
    didSet{
      detailLabel.text = item?.detail
      titleLabel.text = item?.title
      keyButton.titleString = "\(item?.key ?? 0)"
    }
  }
  
  private let detailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRMedium(size: 20)
    return label
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRMedium(size: 30)
    return label
  }()
  
  private let keyButton: LGButton = {
    let button = LGButton()
    button.leftImageSrc = #imageLiteral(resourceName: "keyWhite")
    button.fullyRoundedCorners = true
    button.leftImageWidth = 20
    button.leftImageHeight = 20
    button.bgColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(detailLabel)
    contentView.addSubview(titleLabel)
    contentView.addSubview(keyButton)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      detailLabel.snp.makeConstraints { (make) in
        make.bottom.equalTo(contentView.snp.centerY).offset(-10)
        make.left.equalTo(contentView.snp.leftMargin).inset(10)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(contentView.snp.centerY).offset(10)
        make.left.equalTo(detailLabel)
      }
      
      keyButton.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview()
        make.right.equalToSuperview().inset(20)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
