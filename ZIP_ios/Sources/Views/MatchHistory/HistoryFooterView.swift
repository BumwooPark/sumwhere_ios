//
//  HistoryBottomView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 01/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

class HistoryFooterView: UICollectionReusableView{
  private var didUpdateConstraint = false
  private let addButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  private let addLabel: UILabel = {
    let label = UILabel()
    label.text = "더보기"
    label.font = .AppleSDGothicNeoRegular(size: 10)
    label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(addButton)
    addSubview(addLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      addButton.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
      
      addLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(addButton.snp.bottom).offset(3)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
