//
//  MainHeaderCell.swift
//  ZIP_ios
//
//  Created by xiilab on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import Kingfisher


class MainHeaderCell: UICollectionViewCell{
  
  var item: EventModel?{
    didSet{
      guard let item = item else {return}
      bgImageView.kf.setImage(with: URL(string: item.imageURL.addSumwhereImageURL()), options: [.transition(.fade(0.2))])
    }
  }
  
  
  let bgImageView: UIImageView = {
    var imageView = UIImageView()
    imageView.kf.indicatorType = .activity
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(bgImageView)
    backgroundColor = .white
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 6, height: 6)
    layer.shadowRadius = 10
    layer.shadowOpacity = 5
    
    bgImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
