//
//  ProfileHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 23/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import UIKit


class ProfileCollectionHeaderView: UICollectionReusableView{
  var nickname: String? {
    didSet{
      guard let nickname = nickname else {return}
      let attributedString = NSMutableAttributedString(string: "\(nickname) 님을 대표하는 #성격들 이에요", attributes: [
        .font: UIFont(name: "AppleSDGothicNeo-Medium", size: 16.0)!,
        .foregroundColor: UIColor.black,
        .kern: -1.77
        ])
      
      attributedString.addAttributes([
        .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 16.0)!,
        .foregroundColor: #colorLiteral(red: 0.3872894049, green: 0.5662726164, blue: 0.9160594344, alpha: 1),
        .kern: -1.77
        ], range: NSRange(location: 9+(nickname.count), length: 4))
      
      titleButton.setAttributedTitle(attributedString, for: .normal)
    }
  }
  
  private var didUpdateConstraint = false
    
  private let titleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconCharacter.png"), for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    return button
  }()
  
  private let subTitle: UILabel = {
    let label = UILabel()
    label.text = "내가 생각하는 나는 이런사람!"
    label.font = .AppleSDGothicNeoRegular(size: 12)
    label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleButton)
    addSubview(subTitle)
    
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      titleButton.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(20)
        make.left.equalToSuperview().inset(30)
        make.height.equalTo(20)
      }
      
      subTitle.snp.makeConstraints { (make) in
        make.left.equalTo(titleButton).inset(20)
        make.top.equalTo(titleButton.snp.bottom).offset(3)
        make.height.equalTo(20)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class ProfileStyleCollectionHeaderView: UICollectionReusableView{
  var nickname: String? {
    didSet{
      guard let nickname = nickname else {return}
      let attributedString = NSMutableAttributedString(string: "\(nickname) 님이 관심을 갖는 #여행 스타일 이에요", attributes: [
        .font: UIFont(name: "AppleSDGothicNeo-Medium", size: 16.0)!,
        .foregroundColor: UIColor.black,
        .kern: -1.77
        ])
      
      attributedString.addAttributes([
        .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 16.0)!,
        .foregroundColor: #colorLiteral(red: 0.3872894049, green: 0.5662726164, blue: 0.9160594344, alpha: 1),
        .kern: -1.77
        ], range: NSRange(location: 11+(nickname.count), length: 7))
      
      titleButton.setAttributedTitle(attributedString, for: .normal)
      subTitle.text = "\(nickname)님의 여행스타일과 그에 맞는 관심사에요"
    }
  }
  
  private var didUpdateConstraint = false
  
  private let titleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconplane.png"), for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    return button
  }()
  
  private let subTitle: UILabel = {
    let label = UILabel()
    label.text = "내가 생각하는 나는 이런사람!"
    label.font = .AppleSDGothicNeoRegular(size: 12)
    label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleButton)
    addSubview(subTitle)
    
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      titleButton.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(20)
        make.left.equalToSuperview().inset(30)
        make.height.equalTo(20)
      }
      
      subTitle.snp.makeConstraints { (make) in
        make.left.equalTo(titleButton).inset(20)
        make.top.equalTo(titleButton.snp.bottom).offset(3)
        make.height.equalTo(20)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
