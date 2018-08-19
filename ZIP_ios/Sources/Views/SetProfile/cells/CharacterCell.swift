//
//  CharacterCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

class CharacterCell: UICollectionViewCell{
  
  override var isSelected: Bool{
    didSet{
      titleLabel.textColor = isSelected ? #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1) : .black
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRMedium(size: 30)
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
