//
//  PurchaseCell.swift
//  ZIP_ios
//
//  Created by xiilab on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import UIKit
import StoreKit

final class PurchaseCell: UICollectionViewCell{
  var didUpdateConstraint = false
  var item: SKProduct?{
    didSet{
      guard let item = item else {return}
      productLabel.text = item.productIdentifier
      
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = NumberFormatter.Style.decimal
      let formattedNumber = numberFormatter.string(from: item.price)
      priceLabel.text = "￦\(formattedNumber ?? String())"
    }
  }
  
  let productLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(productLabel)
    contentView.addSubview(priceLabel)
    contentView.backgroundColor = .white
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      productLabel.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview()
        make.left.equalToSuperview().inset(10)
      }
      
      priceLabel.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(10)
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
