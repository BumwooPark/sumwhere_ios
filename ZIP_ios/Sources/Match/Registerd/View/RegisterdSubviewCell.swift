//
//  RegisterdSubviewCell.swift
//  ZIP_ios
//
//  Created by xiilab on 21/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//


class RegisterdSubviewCell: UICollectionViewCell{
  private var didUpdateConstraint = false
  var item: TripSelectorType?{
    didSet{
      guard let item = item else {return}
      switch item {
      case .date(let icon, let start, let end):
        imageView.image = icon
        if let startAt = start.toDate()?.toFormat("M월dd일"), let endAt = end.toDate()?.toFormat("dd일"){
          titleLabel.text = "\(startAt) - \(endAt)"
        }
      case .comment(let icon, let title):
        imageView.image = icon
        titleLabel.text = title
      }
    }
  }
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoSemiBold(size: 11.2)
    label.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    contentView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    contentView.layer.masksToBounds = true
    contentView.setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(10)
        make.centerY.equalToSuperview()
        make.width.height.equalTo(10)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalTo(imageView.snp.right).offset(10)
        make.right.equalToSuperview().inset(10)
        make.centerY.equalToSuperview()
      }
      
      titleLabel.sizeToFit()
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.cornerRadius = contentView.frame.height/2
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

