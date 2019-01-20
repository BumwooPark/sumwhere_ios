//
//  EventContentCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

class EventContentCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  var item: EventSectionModel? {
    didSet{
      guard let item = item else {return}
      eventImageView.kf.setImage(with: URL(string: item.data.imageURL.addSumwhereImageURL())!)
      titleLabel.text = item.data.title
      dateLabel.text = "기간: \(item.data.startAt.toFormat("yyyy-MM-dd")) ~ \(item.data.endAt.toFormat("yyyy-MM-dd"))"
    }
  }
  
  private let eventImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()
  
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(eventImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(dateLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint {
      
      eventImageView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(19)
        make.top.equalToSuperview().inset(29)
        make.height.equalTo(86)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(33)
        make.right.equalTo(eventImageView)
        make.top.equalTo(eventImageView.snp.bottom).offset(18)
      }
      
      dateLabel.snp.makeConstraints { (make) in
        make.left.equalTo(titleLabel)
        make.top.equalTo(titleLabel.snp.bottom).offset(5)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
