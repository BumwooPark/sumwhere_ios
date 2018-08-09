//
//  SetProfileCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class TripStyleCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  var isAddLayer = false
  
  override var isSelected: Bool{
    didSet{
      coverView.backgroundColor = isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2960455908)
    }
  }
  
  var item: TripStyleModel?{
    didSet{
      titleLabel.text = "#\(item?.typeName ?? String())"
      imageView.kf.setImageWithZIP(image: item?.imageURL ?? String())
    }
  }
  
  let coverLayer = CALayer()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.BMJUA(size: 25)
    return label
  }()
  
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let coverView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2960455908)
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(coverView)
    contentView.addSubview(titleLabel)
    setNeedsLayout()
    layoutIfNeeded()
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
      }
      
      coverView.snp.makeConstraints { (make) in
        make.edges.equalTo(imageView)
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
    coverView.layer.cornerRadius = (UIScreen.main.bounds.width - 10) / 4
    coverView.layer.masksToBounds = true

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
