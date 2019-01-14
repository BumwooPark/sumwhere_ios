//
//  NoticeContentCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

class NoticeContentCell: UICollectionViewCell{
  
  let label: UILabel = {
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
