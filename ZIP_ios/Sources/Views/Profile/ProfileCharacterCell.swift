//
//  ProfileCharacterCell.swift
//  ZIP_ios
//
//  Created by xiilab on 21/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit
import TagListView

class ProfileCharacterCell: UICollectionViewCell{
  private var didUpdateConstraint = false
  
  private let titleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconCharacter.png"), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    let attributedString = NSMutableAttributedString(string: "승완 님을 대표하는 #성격들 이에요", attributes: [
      .font: UIFont(name: "AppleSDGothicNeo-Medium", size: 16.0)!,
      .foregroundColor: UIColor(white: 0.0, alpha: 1.0),
      .kern: -1.77
      ])
    
    attributedString.addAttributes([
      .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 16.0)!,
      .foregroundColor: #colorLiteral(red: 0.3872894049, green: 0.5662726164, blue: 0.9160594344, alpha: 1),
      .kern: -1.77
      ], range: NSRange(location: 11, length: 4))

    button.titleLabel?.attributedText = attributedString
    return button
  }()
  
  private let subTitle: UILabel = {
    let label = UILabel()
    label.text = "내가 생각하는 나는 이런사람!"
    label.font = .AppleSDGothicNeoRegular(size: 12)
    label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
    return label
  }()
  
  private let tagView: TagListView = {
    let tagView = TagListView()
    tagView.addTags(["차분한","차분한","차분한","차분한"])
    return tagView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleButton)
    contentView.addSubview(subTitle)
    contentView.addSubview(tagView)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      titleButton.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(30)
        make.centerX.equalToSuperview()
      }
      
      subTitle.snp.makeConstraints { (make) in
        make.left.equalTo(titleButton)
        make.top.equalTo(titleButton.snp.bottom).offset(3)
      }
      
      tagView.snp.makeConstraints { (make) in
        make.top.equalTo(subTitle.snp.bottom).offset(30)
        make.centerX.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


