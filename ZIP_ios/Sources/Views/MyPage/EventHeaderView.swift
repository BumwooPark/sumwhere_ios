//
//  EventInfoHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit

class EventHeaderView: UICollectionReusableView{
  
  var item: EventSectionModel? {
    didSet{
      titleLabel.text = item?.data.text
      log.info(item?.data.createAt)
    }
  }
  
  private var didupdateConstraint = false
  
  private let topLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = .AppleSDGothicNeoRegular(size: 17)
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 15)
    label.textColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
    return label
  }()
  
  private let foldButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonNoticeFold.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "buttonNoticeUnfold.png"), for: .selected)
    return button
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    addSubview(dateLabel)
    addSubview(foldButton)
    addSubview(topLine)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didupdateConstraint {
      
      topLine.snp.makeConstraints { (make) in
        make.top.left.right.equalToSuperview()
        make.height.equalTo(1)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(26)
        make.centerY.equalToSuperview().inset(-10)
        make.right.equalToSuperview().inset(76)
      }
      
      foldButton.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(19)
        make.top.equalTo(titleLabel)
      }
      
      dateLabel.snp.makeConstraints { (make) in
        make.left.equalTo(titleLabel)
        make.top.equalTo(titleLabel.snp.bottom).offset(5)
      }
      
      
      didupdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
