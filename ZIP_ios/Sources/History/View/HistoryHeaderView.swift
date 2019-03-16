//
//  HistoryHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 01/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

class HistoryHeaderView: UICollectionReusableView{
  
  private var didUpdateConstraint = false
  var item: TripPlaceJoin?{
    didSet{
      guard let item = item else {return}
      placeLabel.text = item.tripPlace.trip
    }
  }
  
  private let imageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "emptyChatlistIcon.png"))
    return imageView
  }()
  
  private let placeLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 19)
    label.textColor = #colorLiteral(red: 0.0431372549, green: 0.0431372549, blue: 0.0431372549, alpha: 1)
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(placeLabel)
    addSubview(imageView)
    addSubview(dateLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      placeLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(30)
        make.left.equalToSuperview().inset(50)
      }
      
      imageView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalTo(placeLabel)
        make.height.equalTo(10)
      }
      
      dateLabel.snp.makeConstraints { (make) in
        make.left.equalTo(placeLabel)
        make.top.equalTo(placeLabel.snp.bottom).offset(5)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
