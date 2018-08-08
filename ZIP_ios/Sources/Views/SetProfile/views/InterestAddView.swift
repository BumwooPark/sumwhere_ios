//
//  CharactorAddView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
import LGButton

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
  
  let commitButton: LGButton = {
    let button = LGButton()
    button.bgColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    button.titleString = "등록하기"
    button.titleFontName = "BMJUAOTF"
    button.titleFontSize = 30
    button.cornerRadius = 5
    return button
  }()
  
  lazy var commitAction = commitButton
    .rx
    .controlEvent(.touchUpInside)
    .map{_ in return ()}
    .share()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(plusButton)
    self.addSubview(commitButton)
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      plusButton.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalToSuperview().inset(10)
        make.height.equalTo(40)
        make.width.equalTo(100)
      }
      
      commitButton.snp.makeConstraints { (make) in
        make.centerX.height.equalTo(plusButton)
        make.width.equalTo(150)
        make.top.equalTo(plusButton.snp.bottom).offset(20)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
