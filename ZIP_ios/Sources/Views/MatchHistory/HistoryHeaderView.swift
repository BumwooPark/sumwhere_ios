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
  
  let placeLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 19)
    label.textColor = #colorLiteral(red: 0.0431372549, green: 0.0431372549, blue: 0.0431372549, alpha: 1)
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(placeLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
