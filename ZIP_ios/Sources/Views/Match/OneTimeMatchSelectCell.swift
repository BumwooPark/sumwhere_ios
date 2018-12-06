//
//  OneTimeMatchSelectCell.swift
//  ZIP_ios
//
//  Created by xiilab on 04/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit


final class OneTimeMatchSelectCell: UICollectionViewCell {
  var didUpdateConstraint = false
  var ifInsertSubLayer = false
  let timeLeftLabel: UILabel = {
    let label = UILabel()
    label.text = "2시간 15분뒤 여행 시작"
    label.font = .AppleSDGothicNeoBold(size: 17)
    return label
  }()
  
  let timeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "currentTimeIcon.png"), for: .normal)
    button.setTitle("오늘, AM 08:00", for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    button.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1), for: .normal)
    return button
  }()
  
  let dividView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    return view
  }()
  
  let circleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 60
    view.layer.masksToBounds = true
    return view
  }()
  
  let circleViewSecond: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 59
    view.backgroundColor = .white
    return view
  }()
  
  let profileImageView: UIImageView = {
    let view = UIImageView()
    view.layer.cornerRadius = 53
    view.backgroundColor = .blue
    return view
  }()
  
  let nickNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.OTGulimB(size: 18.2)
    label.text = "손승완"
    return label
  }()
  
  let distanceLabel: UILabel = {
    let label = UILabel()
    label.text = "나와 500m 간격에 있어요"
    return label
  }()
  
  let textLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    label.text = "한강 갔다가 일본식 라면 먹고 싶어요\n같이 드실분?"
    label.lineBreakMode = .byTruncatingTail
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 20
    contentView.backgroundColor = .white
    contentView.addSubview(timeLeftLabel)
    contentView.addSubview(timeButton)
    contentView.addSubview(dividView)
    contentView.addSubview(circleView)
    circleView.addSubview(circleViewSecond)
    circleViewSecond.addSubview(profileImageView)
    contentView.addSubview(nickNameLabel)
    contentView.addSubview(distanceLabel)
    contentView.addSubview(textLabel)
    
    setNeedsUpdateConstraints()
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    if !ifInsertSubLayer && circleView.bounds.size != .zero{
      circleView.gradientBackground(from: #colorLiteral(red: 0.1803921569, green: 0.5647058824, blue: 1, alpha: 1), to: #colorLiteral(red: 0.4352941176, green: 0.4117647059, blue: 1, alpha: 1), direction: GradientDirection.bottomToTop)
      ifInsertSubLayer = true
    }
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      timeLeftLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(25)
        make.centerX.equalToSuperview()
      }
      
      timeButton.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(timeLeftLabel.snp.bottom).offset(2)
      }
      
      dividView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(26)
        make.top.equalTo(timeButton.snp.bottom).offset(12)
        make.height.equalTo(2)
      }
      
      circleView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(dividView.snp.bottom).offset(19)
        make.height.width.equalTo(120)
      }
      
      circleViewSecond.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
      }
      
      profileImageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
      }
      
      nickNameLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(circleView.snp.bottom).offset(10)
      }
      
      distanceLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(nickNameLabel.snp.bottom).offset(4)
      }
      
      textLabel.snp.makeConstraints { (make) in
        make.bottom.left.right.equalToSuperview().inset(13)
        make.top.equalTo(distanceLabel.snp.bottom).offset(20)
      }
      
      
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
