//
//  MainViewCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import TagListView
import Kingfisher

final class MainViewCell: UICollectionViewCell{
  private var didUpdateConstraint = false
  
  var item: CountryWithPlace? {
    didSet{
      guard let item = item else {return}
      backgroundImage.kf.setImage(with: URL(string: item.tripPlace.imageURL.addSumwhereImageURL()), options: [.transition(.fade(0.2))])
      let attributedString = NSMutableAttributedString(string: "\(item.tripPlace.trip) ", attributes: [.font: UIFont.OTGulimL(size: 28.5),.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
      attributedString.append(NSAttributedString(string: item.country.name, attributes: [.font: UIFont.AppleSDGothicNeoRegular(size: 15),.foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)]))
      titleLabel.attributedText = attributedString
      tagView.removeAllTags()
      tagView.addTags(item.tripPlace.keywords)
    }
    
  }
  
  let backgroundImage: UIImageView = {
    var imageView = UIImageView()
    imageView.kf.indicatorType = .activity
    return imageView
  }()
  
  let contentBox: UIView = {
    let view = UIImageView()
    view.layer.cornerRadius = 18
    view.backgroundColor = .white
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    return view
  }()
  
  let keywordButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconTag.png"), for: .normal)
    button.setTitle("추천 키워드", for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    button.titleLabel?.font = UIFont.AppleSDGothicNeoMedium(size: 14)
    button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
    return button
  }()
  
  let tagView: TagListView = {
    let tagView = TagListView()
//    tagView.alignment = .center
    tagView.cornerRadius = 11
    tagView.borderColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    tagView.borderWidth = 1.5
    tagView.tagBackgroundColor = .white
    tagView.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    tagView.marginX = 5
    tagView.marginY = 5
    tagView.paddingY = 10
    tagView.paddingX = 10
    tagView.textFont = .AppleSDGothicNeoMedium(size: 10.5)
    return tagView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(backgroundImage)
    contentView.addSubview(contentBox)
    contentBox.addSubview(titleLabel)
    contentBox.addSubview(dividLine)
    contentBox.addSubview(keywordButton)
    contentBox.addSubview(tagView)
    
    contentView.layer.shadowColor = UIColor.gray.cgColor
    contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
    contentView.layer.shadowRadius = 5
    contentView.layer.shadowOpacity = 5
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      backgroundImage.snp.makeConstraints { (make) in
        make.top.left.right.equalToSuperview()
        make.height.equalTo(204)
      }
      
      contentBox.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(13)
        make.bottom.equalToSuperview().inset(39)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(34)
        make.top.equalToSuperview().inset(28)
      }
      
      dividLine.snp.makeConstraints { (make) in
        make.right.left.equalToSuperview().inset(15)
        make.height.equalTo(1.5)
        make.top.equalTo(titleLabel.snp.bottom).offset(15)
      }
      
      keywordButton.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(35)
        make.top.equalTo(dividLine.snp.bottom).offset(16)
      }
      
      tagView.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(30)
        make.right.equalToSuperview().inset(11)
        make.bottom.equalToSuperview().inset(16)
        make.top.equalTo(keywordButton.snp.bottom).offset(10)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
