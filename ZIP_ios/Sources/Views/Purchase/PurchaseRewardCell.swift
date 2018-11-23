//
//  PurchaseRewardCell.swift
//  ZIP_ios
//
//  Created by BumwooPark on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import UIKit
import SwiftyImage

class PurchaseRewardCell: UICollectionViewCell{
  
  let attributedString: (Int) -> NSMutableAttributedString = { reward in
    let attributedString = NSMutableAttributedString(string: "\(reward)",
      attributes: [.font: UIFont.NanumSquareRoundEB(size: 21.2),.foregroundColor: #colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1)])
    attributedString.append(NSAttributedString(string: " 개", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 15.6)]))
    return attributedString
  }
  
  var item: RewardPurchase?{
    didSet{
      guard let item = item else {return}
      switch item.rewardType{
      case let .Advertisement(title, reward, _):
        keyTitle.attributedText = attributedString(reward)
        rewardButton.setTitle(title, for: .normal)
      case let .Friends(title, reward, _):
        keyTitle.attributedText = attributedString(reward)
        rewardButton.setTitle(title, for: .normal)
      case let .Attendance(enable, disable, reward, _):
        keyTitle.attributedText = attributedString(reward)
        rewardButton.setTitle(enable, for: .normal)
        rewardButton.setTitle(disable, for: .disabled)
      }
    }
  }
  let selectedColor = #colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1)
  let unSelectedColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
  var didUpdateConstraint = false
  
  private let keyTitle: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var rewardButton: UIButton = {
    let button = UIButton()
    button.isUserInteractionEnabled = false
    button.layer.cornerRadius = 7
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 12)
    button.backgroundColor = selectedColor
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 5.5
    contentView.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    contentView.layer.borderWidth = 1.1
    contentView.backgroundColor = .white
    contentView.addSubview(keyTitle)
    contentView.addSubview(rewardButton)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      keyTitle.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(10)
        make.centerY.equalToSuperview()
      }
      
      rewardButton.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(13)
        make.centerY.equalToSuperview()
        make.height.equalTo(34)
        make.width.equalTo(67)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
