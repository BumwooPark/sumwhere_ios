//
//  MainCollectionHeaderView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class MainCollectionHeaderView: UICollectionReusableView{
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRBold(size: 15)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(20)
      make.centerY.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
