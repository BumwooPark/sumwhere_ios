//
//  PurchaseEmptyView.swift
//  ZIP_ios
//
//  Created by xiilab on 24/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

class PurchaseEmptyView: UIView{
  
  private var didUpdateConstraint = false
  private let icon: UIImageView = {
    let image = UIImageView(image: #imageLiteral(resourceName: "purchasenoticon.png"))
    return image
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    let attributedString = NSMutableAttributedString(
      string: "이용 내역이 없습니다.\n\n",
      attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 20),.foregroundColor: #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)])
    attributedString.append(NSAttributedString(string: "스토어를 통해\n키를 구매해보세요!", attributes: [.font: UIFont.AppleSDGothicNeoRegular(size: 15),.foregroundColor: #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)]))
    label.attributedText = attributedString
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(icon)
    addSubview(titleLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      icon.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-100)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(icon.snp.bottom).offset(24)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
