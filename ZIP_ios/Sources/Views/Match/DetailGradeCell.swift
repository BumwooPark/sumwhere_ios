//
//  DetailgradeCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import Cosmos

class DetailGradeCell: UICollectionViewCell, MatchDataSavable{
  var item: UserTripJoinModel?{
    didSet{
      
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "동행평점"
    label.font = UIFont.NotoSansKRBold(size: 20)
    return label
  }()
  
  private let ratingView: CosmosView = {
    let view = CosmosView()
    view.settings.starSize = 40
    view.settings.starMargin = 5
    view.settings.filledColor = #colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1)
    view.settings.emptyColor = .white
    view.settings.filledBorderColor = #colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1)
    view.settings.fillMode = .full
    view.settings.updateOnTouch = false
    view.rating = 4
    view.settings.totalStars = 5
    return view
  }()
  
  private let ratingLabel: UILabel = {
    let label = UILabel()
    label.text = "4점"
    label.font = UIFont.NotoSansKRBold(size: 17)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(ratingView)
    addSubview(titleLabel)
    addSubview(ratingLabel)
    ratingView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(20)
    }
    
    ratingLabel.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(10)
      make.centerX.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
