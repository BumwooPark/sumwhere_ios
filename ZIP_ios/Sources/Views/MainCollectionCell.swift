//
//  MainCollectionCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class MainCollectionCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  
  var item: MainModel?{
    didSet{
      titleLabel.text = item?.title
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRMedium(size: 30)
    return label
  }()
  
  let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .blue
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(backImageView)
    backImageView.addSubview(titleLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      backImageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
