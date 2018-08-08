//
//  SetProfileCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class TripStyleCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  
  override var isSelected: Bool{
    didSet{
      imageView.backgroundColor = isSelected ? .blue : .red
    }
  }
  
  var item: TripStyleModel?{
    didSet{
      titleLabel.text = "#\(item?.typeName ?? String())"
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.BMJUA(size: 25)
    return label
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.borderWidth = 1
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    imageView.addSubview(titleLabel)
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.layer.cornerRadius = (UIScreen.main.bounds.width - 10) / 4
    imageView.layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
