//
//  TripTableHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 24..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift

class TripStyleHeaderView: UITableViewHeaderFooterView {
  typealias Item = TripStyleModel
  
  var disposeBag = DisposeBag()
  
  var didUpdateConstraint = false
  var item: Item?{
    didSet{
      guard let item = item else {return}
      titleLabel.text = item.tripStyle.typeName
      selectedButton.isSelected = item.isOpend
      titleLabel.textColor = item.isOpend ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : .black
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 18)
    
    return label
  }()
  
  private let selectedButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "oval.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "ovalselected.png"), for: .selected)
    return button
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = .white
    contentView.addSubview(titleLabel)
    contentView.addSubview(selectedButton)
    setNeedsUpdateConstraints()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(36)
        make.centerY.equalToSuperview()
      }
      
      selectedButton.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(36)
        make.centerY.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
