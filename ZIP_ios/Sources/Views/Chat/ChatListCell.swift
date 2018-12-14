//
//  ChatListCell.swift
//  ZIP_ios
//
//  Created by xiilab on 10/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

final class ChatListCell: UICollectionViewCell {
  
  var item: ChatListModel? {
    didSet{
    }
  }
  
  var didUpdateConstraint = false
  private let profileImage: UIImageView = {
    let view = UIImageView()
    view.backgroundColor = .blue
    view.layer.cornerRadius = 37/2
    view.layer.masksToBounds = true
    return view
  }()
  
  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoSemiBold(size: 15)
    label.text = "아이린"
    return label
  }()
  
  private let commentLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 12)
    label.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    label.text = "Mama, just killed a man Put a gun against"
    return label
  }()
  
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.text = "5분전"
    label.font = .AppleSDGothicNeoMedium(size: 11)
    label.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    return label
  }()
  
  private let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    return view
  }()
  
  private let countButton: UIButton = {
    let button = UIButton()
    button.setTitle("3", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 11.6)
    button.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.3764705882, blue: 0.4039215686, alpha: 1)
    button.layer.cornerRadius = 10
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(profileImage)
    contentView.addSubview(nickNameLabel)
    contentView.addSubview(commentLabel)
    contentView.addSubview(bottomView)
    contentView.addSubview(timeLabel)
    contentView.addSubview(countButton)
    setNeedsUpdateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    log.info(countButton.intrinsicContentSize)
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      profileImage.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(30)
        make.width.height.equalTo(37)
        make.centerY.equalToSuperview()
      }
      
      nickNameLabel.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview().inset(-10)
        make.left.equalTo(profileImage.snp.right).offset(10)
      }
      
      commentLabel.snp.makeConstraints { (make) in
        make.left.equalTo(nickNameLabel)
        make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
      }
      
      bottomView.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(60)
        make.right.bottom.equalToSuperview()
        make.height.equalTo(1)
      }
      
      timeLabel.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(30)
        make.centerY.equalTo(nickNameLabel)
      }
      
      countButton.snp.makeConstraints { (make) in
        make.centerX.equalTo(timeLabel)
        make.top.equalTo(timeLabel.snp.bottom).offset(5)
        make.height.width.equalTo(20)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
