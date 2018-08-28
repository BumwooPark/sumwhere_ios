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
      backImageView.image = item?.image
      titleLabel.text = item?.title
      detailLabel.text = item?.detail
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRBold(size: 30)
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  let detailLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.NotoSansKRMedium(size: 15)
    return label
  }()
  
  let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .blue
    imageView.layer.cornerRadius = 20
    imageView.clipsToBounds = true
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(backImageView)
    backImageView.addSubview(titleLabel)
    backImageView.addSubview(detailLabel)
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 5
    layer.shadowOffset = CGSize(width: 5, height: 5)
    layer.cornerRadius = 20
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      backImageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.top.equalToSuperview().inset(20)
      }
      
      detailLabel.snp.makeConstraints { (make) in
        make.left.equalTo(titleLabel.snp.left)
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
