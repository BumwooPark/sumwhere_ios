//
//  EmptyChatView.swift
//  ZIP_ios
//
//  Created by xiilab on 13/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class EmptyChatView: UIView {
  var didUpdateConstraint = false
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "emptyChatlistIcon.png")
    return imageView
  }()
  
  private let stateLabel: UILabel = {
    let label = UILabel()
    label.text = "참여중인 채팅이 없어요"
    label.font = UIFont.AppleSDGothicNeoSemiBold(size: 20)
    label.textColor = #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)
    return label
  }()
  
  private let detailLabel: UILabel = {
    let label = UILabel()
    label.text = "매칭 신청을 통해\n함께 여행을 떠날 친구를 찾아보세요!"
    label.textAlignment = .center
    label.numberOfLines = 2
    label.font = UIFont.AppleSDGothicNeoRegular(size: 15)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    addSubview(stateLabel)
    addSubview(detailLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
        make.center.equalToSuperview().inset(-50)
      }
      
      stateLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(imageView.snp.bottom).offset(20)
      }
      
      detailLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(stateLabel.snp.bottom).offset(30)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
