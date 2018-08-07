//
//  CharacterHeaderView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


class CharacterHeaderView: UICollectionReusableView{
  
  var didUpdateConstraint = false
  
  let styleLabel: UILabel = {
    let label = UILabel()
    label.text = "나의 성격을 골라주세요"
    label.font = UIFont.BMJUA(size: 20)
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(styleLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      styleLabel.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    
    super.updateConstraints()
  }
}
