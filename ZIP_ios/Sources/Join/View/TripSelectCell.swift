//
//  TripSelectCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

class TripSelectCell: UICollectionViewCell{
  var didUpdateConstraint = false
  
  override var isSelected: Bool{
    didSet{
      selectButton.isSelected = isSelected
    }
  }
  
  var item: SelectTripStyleModel.TripType? {
    didSet{
      guard let item = item else {return}
      if case let .type(name,select,selected) = item {
        titleLabel.text = name
        selectButton.setImage(select, for: .normal)
        selectButton.setImage(selected, for: .selected)
      }
    }
  }
  
  private let selectButton: UIButton = {
    let button = UIButton()
    button.isUserInteractionEnabled = false
    return button
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 12)
    label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(selectButton)
    contentView.addSubview(titleLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      selectButton.snp.makeConstraints { (make) in
        make.left.right.top.equalToSuperview()
        make.height.equalTo(73)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(selectButton.snp.bottom).offset(10)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
