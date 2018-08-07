//
//  CharactorAddView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

class InterestAddView: UICollectionReusableView{
  
  var didUpdateConstraint = false
  
  lazy var plusButton: UIButton = {
    let button = UIButton()
    button.setTitle("+", for: .normal)
    button.titleLabel?.font = UIFont.BMJUA(size: 30)
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.setTitleColor(.black, for: .normal)
    button.isUserInteractionEnabled = true
    button.isEnabled = true
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(plusButton)
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      plusButton.snp.makeConstraints { (make) in
        make.centerX.bottom.equalToSuperview()
        make.height.equalTo(40)
        make.width.equalTo(100)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
