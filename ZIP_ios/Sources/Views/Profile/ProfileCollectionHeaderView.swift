//
//  ProfileHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 23/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import UIKit


class ProfileCollectionHeaderView: UICollectionReusableView{
  private var didUpdateConstraint = false
    
  private let titleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconCharacter.png"), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    let attributedString = NSMutableAttributedString(string: "승완 님을 대표하는 #성격들 이에요", attributes: [
      .font: UIFont(name: "AppleSDGothicNeo-Medium", size: 16.0)!,
      .foregroundColor: UIColor.black,
      .kern: -1.77
      ])
    
    attributedString.addAttributes([
      .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 16.0)!,
      .foregroundColor: #colorLiteral(red: 0.3872894049, green: 0.5662726164, blue: 0.9160594344, alpha: 1),
      .kern: -1.77
      ], range: NSRange(location: 11, length: 4))
    button.setTitleColor(.black, for: .normal)
    button.setAttributedTitle(attributedString, for: .normal)
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
