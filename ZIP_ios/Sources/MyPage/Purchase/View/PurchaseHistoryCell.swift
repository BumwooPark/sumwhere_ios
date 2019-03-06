//
//  PurchaseHistoryCell.swift
//  ZIP_ios
//
//  Created by xiilab on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import SwiftDate

class PurchaseHistoryCell: UICollectionViewCell {
  
  let dateConvert: (String) -> (String?) = { date in
    return date.toISODate()?.toFormat("yyyy.MM.dd")
  }
  
  var item: PurchaseHistoryModel?{
    didSet{
      guard let item = item else {return}
      keyButton.isSelected = item.positive_value
      historyTitle.text = item.message
      dateLabel.text = dateConvert(item.create_at)
      keyStateLabel.text = item.positive_value ? "+ \(item.key)개" : "- \(item.key)개"
      keyStateLabel.isHighlighted = item.positive_value
    }
  }
  
  private var didUpdateConstraint = false
  private let keyButton: UIButton = {
    let button = UIButton()
    button.isUserInteractionEnabled = false
    button.setImage(#imageLiteral(resourceName: "keyenable.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "keyminus.png"), for: .selected)
    return button
  }()
  
  private let historyTitle: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 15)
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .NanumSquareRoundEB(size: 11)
    label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
    return label
  }()
  
  private let keyStateLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoSemiBold(size: 15)
    label.textColor = #colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1)
    label.highlightedTextColor = #colorLiteral(red: 0.8039215686, green: 0.3333333333, blue: 0.3019607843, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(keyButton)
    contentView.addSubview(historyTitle)
    contentView.addSubview(dateLabel)
    contentView.addSubview(keyStateLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      keyButton.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(28)
        make.centerY.equalToSuperview()
      }
      
      historyTitle.snp.makeConstraints { (make) in
        make.left.equalTo(keyButton.snp.right).offset(5)
        make.centerY.equalTo(keyButton)
      }
      
      dateLabel.snp.makeConstraints { (make) in
        make.left.equalTo(historyTitle)
        make.top.equalTo(historyTitle.snp.bottom).offset(5)
      }
      
      keyStateLabel.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(30)
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
