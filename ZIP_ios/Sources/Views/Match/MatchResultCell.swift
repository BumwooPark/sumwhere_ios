//
//  ResultMatchCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import SwiftDate

class MatchResultCell: UICollectionViewCell{
  
  private var didUpdateConstraint = false
  var item: UserTripJoinModel?{
    didSet{
      guard let item = item else {return}
      profileImage.kf.setImage(with: URL(string: item.user.mainProfileImage?.addSumwhereImageURL() ?? "")!)
      titleLabel.text = timeCalculate(time: item.trip.startDate)
      nickNameLabel.attributedText = nameAgePlaceAttributedString(item: item)
      explainLabel.text = item.trip.activity
      
      if let dateString = item.trip.startDate.toDate()?.date.toFormat("yyyy MM월 dd일"){
          startTimeButton.setTitle(dateString, for: .normal)
      }
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.AppleSDGothicNeoBold(size: 17.8)
    return label
  }()
  
  private let startTimeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "currentTimeIcon.png"), for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoRegular(size: 14.7)
    button.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1), for: .normal)
    button.isEnabled = false
    return button
  }()
  
  private let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    return view
  }()
  
  private let gradientView: UIView = UIView()
  private let emptyView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.masksToBounds = true
    return view
  }()
  
  private let profileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let nickNameLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let explainLabel: UILabel = {
    let label = UILabel()
    label.layer.cornerRadius = 6
    label.layer.masksToBounds = true
    label.textAlignment = .center
    label.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 20
    contentView.backgroundColor = .white
    contentView.addSubview(titleLabel)
    contentView.addSubview(startTimeButton)
    contentView.addSubview(dividLine)
    contentView.addSubview(gradientView)
    gradientView.addSubview(emptyView)
    contentView.addSubview(nickNameLabel)
    emptyView.addSubview(profileImage)
    contentView.addSubview(nickNameLabel)
    contentView.addSubview(explainLabel)
    
    setNeedsUpdateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientView.layer.cornerRadius = gradientView.frame.width/2
    gradientView.clipsToBounds = true
    gradientView.gradientBackground(from: #colorLiteral(red: 0.4352941176, green: 0.4117647059, blue: 1, alpha: 1), to: #colorLiteral(red: 0.1803921569, green: 0.5647058824, blue: 0.8823529412, alpha: 1), direction: GradientDirection.bottomToTop)
    emptyView.layer.cornerRadius = emptyView.frame.width/2
    profileImage.layer.cornerRadius = profileImage.frame.width/2
  }
  
  func nameAgePlaceAttributedString(item: UserTripJoinModel) -> NSMutableAttributedString{
    var attributedString = NSMutableAttributedString()
    if let nickname = item.user.nickname {
      attributedString.append(NSAttributedString(string: nickname, attributes: [.font: UIFont.OTGulimB(size: 20)]))
    }
    
    if let age = item.user.age {
      attributedString.append(NSAttributedString(string: " \(age)살", attributes: [.font: UIFont.AppleSDGothicNeoLight(size: 17.6)]))
    }
    
    return attributedString
  }
  
  
  func timeCalculate(time: String) -> String {
    guard let startDate = time.toDate()?.date else {return String()}
    
    let result = startDate - Date()
    
    let day = result.day ?? 0
    let week = result.weekOfYear ?? 0
    let days = day + (week * 7)
    
    return days > 0 ? "D-\(days)일뒤 여행시작" : "D+\(abs(days))일전 여행시작"
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint {
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(33)
        make.centerX.equalToSuperview()
      }
      
      startTimeButton.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(4.2)
        make.centerX.equalToSuperview()
      }
      
      dividLine.snp.makeConstraints { (make) in
        make.top.equalTo(startTimeButton.snp.bottom).offset(22.8)
        make.left.right.equalToSuperview().inset(26)
        make.height.equalTo(2)
      }
      
      gradientView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(dividLine.snp.bottom).offset(18)
        make.height.width.equalTo(132)
      }
      
      emptyView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
      }
      
      profileImage.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
      }
      
      nickNameLabel.snp.makeConstraints { (make) in
        make.top.equalTo(gradientView.snp.bottom).offset(13.2)
        make.centerX.equalToSuperview()
      }
      
      explainLabel.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview().inset(11)
        make.height.equalTo(71)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
