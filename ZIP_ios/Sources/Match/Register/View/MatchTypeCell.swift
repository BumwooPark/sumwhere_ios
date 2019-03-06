//
//  MatchTypeCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

class MatchTypeCell: UICollectionViewCell{
  
  var item: MatchType?{
    didSet{
      guard let item = item else {return}
      titleLabel.text = item.title
      bgImage.kf.setImage(with: URL(string: item.imageUrl.addSumwhereImageURL())!,options: [.transition(.fade(0.2)),.cacheOriginalImage])
      explainLabel.text = item.subTitle
      if !item.isEnable{
        titleLabel.text = "업데이트 예정"
      }
    }
  }

  private var didUpdateConstraint = false
  
  private let bgImage: UIImageView = {
    var imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.kf.indicatorType = .activity
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.OTGulimL(size: 30)
    label.textColor = .white
    return label
  }()
  
  private let explainLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.AppleSDGothicNeoSemiBold(size: 11)
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 10
    contentView.layer.masksToBounds = true
    contentView.addSubview(bgImage)
    contentView.addSubview(titleLabel)
    contentView.addSubview(explainLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      bgImage.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
      
      explainLabel.snp.makeConstraints { (make) in
        make.bottom.equalTo(titleLabel.snp.top).offset(-6)
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
