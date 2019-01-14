//
//  EventContentCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

class EventContentCell: UICollectionViewCell{
  
  var item: EventSectionModel? {
    didSet{
      
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
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
