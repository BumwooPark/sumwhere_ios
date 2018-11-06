//
//  PurchaseHeaderView.swift
//  ZIP_ios
//
//  Created by xiilab on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import UIKit

class PurchaseHeaderView: UICollectionReusableView {
  private var didUpdateConstrain = false
  
  let label: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoLight(size: 13)
    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstrain{
      label.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(20)
        make.centerY.equalToSuperview()
      }
      didUpdateConstrain = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
