//
//  HistoryCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 01/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSources
import Kingfisher

class HistoryCell: UICollectionViewCell{
  
  var disposeBag = DisposeBag()
  var didUpdateConstraint = false
  
  private let profileImageView: UIImageView = {
    var imageView = UIImageView()
    imageView.kf.indicatorType = .activity
    return imageView
  }()
  
  private let profileTitle: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .center
    return label
  }()
  
  var item: MatchHistoryModel?{
    didSet{
      guard let item  = item else {return}
      profileImageView.kf.setImage(with: URL(string: item.profile.image1.addSumwhereImageURL()), options: [.transition(.fade(0.2))])
      let attributedString = NSMutableAttributedString(string: (item.user.nickname ?? String()) + "\n", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 14.2),.foregroundColor: #colorLiteral(red: 0.0431372549, green: 0.0431372549, blue: 0.0431372549, alpha: 1)])
      attributedString.append(NSAttributedString(string: "\(item.profile.age), \(item.user.gender! == "male" ? "남" : "여")", attributes: [.font: UIFont.AppleSDGothicNeoRegular(size: 10.5),.foregroundColor: #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)]))
      profileTitle.attributedText = attributedString
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white
    contentView.addSubview(profileImageView)
    contentView.addSubview(profileTitle)
    contentView.layer.shadowColor = UIColor.gray.cgColor
    contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
    contentView.layer.shadowRadius = 5
    contentView.layer.shadowOpacity = 5
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      profileImageView.snp.makeConstraints { (make) in
        make.left.right.top.equalToSuperview()
        make.height.equalTo(profileImageView.snp.width)
      }
      
      profileTitle.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.top.equalTo(profileImageView.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
