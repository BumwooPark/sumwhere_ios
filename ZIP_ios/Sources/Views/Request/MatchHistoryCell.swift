//
//  ReceiveCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

final class MatchHistoryCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  var item: MatchRequestHistoryModel?{
    didSet{
      
    }
  }
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.text = "D - 3"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(dateLabel)
    
    
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      dateLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(10)
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
