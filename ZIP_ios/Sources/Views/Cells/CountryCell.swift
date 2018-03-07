//
//  CountryCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 3. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

class CountryCell: UICollectionViewCell{
  
  var model: CountryViewModel.Item?{
    didSet{
      guard let model = model else {return}
      image.kf.setImage(with: model.imageURL)
      countryLabel.text = model.country_name
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  
  private let image: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .blue
    return image
  }()
  
  private let countryLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(image)
    contentView.addSubview(countryLabel)
    addConstraint()
  }
  
  private func addConstraint(){
    
    image.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.size.equalToSuperview().dividedBy(2)
    }
    
    countryLabel.snp.makeConstraints { (make) in
      make.left.bottom.right.equalToSuperview()
      make.top.equalTo(image.snp.bottom)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    image.layer.cornerRadius = image.frame.width/2
    image.layer.masksToBounds = true
  }
}
