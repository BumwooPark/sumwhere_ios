//
//  PurchaseCell.swift
//  ZIP_ios
//
//  Created by xiilab on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import UIKit
import StoreKit
import Moya
import RxSwift

final class PurchaseCell: UICollectionViewCell{
  let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  
  var item: SKProduct?{
    didSet{
      guard let item = item else {return}
      self.productMapper(name: item.productIdentifier)
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = NumberFormatter.Style.decimal
      let formattedNumber = numberFormatter.string(from: item.price)
      priceLabel.text = "\(formattedNumber ?? String())원"
    }
  }
  
  let productLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 14.3)
    label.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
    return label
  }()
  
  let saleButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 12.5
    button.layer.borderWidth = 1
    button.layer.borderColor = #colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1)
    button.setTitleColor(#colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1), for: .normal)
    button.titleLabel?.font = .NanumSquareRoundEB(size: 10)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 5.5
    contentView.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    contentView.layer.borderWidth = 1.1
    contentView.addSubview(productLabel)
    contentView.addSubview(priceLabel)
    contentView.addSubview(saleButton)
    contentView.backgroundColor = .white
    
    setNeedsUpdateConstraints()
  }
  
  func productMapper(name: String){
    let result = AuthManager.instance.provider.request(.IAPInfo(productName: name))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<PurchaseProduct>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
    
    result.elements()
      .subscribeNext(weak: self) { (weakSelf) -> (PurchaseProduct) -> Void in
        return { product in
          let count = Double(product.productName) ?? 0
          
          
          let attributedString = NSMutableAttributedString(string: product.productName, attributes: [.font: UIFont.NanumSquareRoundB(size: 21.2),.foregroundColor: #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1),.strikethroughStyle: 1.0,.strikethroughColor: UIColor(red:0.657, green:0.657, blue:0.657, alpha:1.0)])
        
          attributedString.append(NSAttributedString(string: " "))
          attributedString.append(NSAttributedString(string: "\(Int(count + (count * product.increase)))", attributes: [.font: UIFont.NanumSquareRoundB(size: 21.2),.foregroundColor: #colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1)]))
          
          attributedString.append(NSAttributedString(string: "개", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 15.6)]))
          weakSelf.productLabel.attributedText = attributedString
          weakSelf.saleButton.isHidden = product.increase > 0 ? false : true
          weakSelf.saleButton.setTitle("\(Int(product.increase * 100))% 더", for: .normal)
        }
      }.disposed(by: disposeBag)
    
    result.errors()
      .subscribe(onNext: { (error) in
        (error as? MoyaError)?.GalMalErrorHandler()
      }).disposed(by: disposeBag)
    
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
      
      saleButton.snp.makeConstraints { (make) in
        make.left.equalTo(productLabel.snp.right).offset(10)
        make.height.equalTo(25)
        make.width.equalTo(48)
        make.centerY.equalTo(productLabel)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
