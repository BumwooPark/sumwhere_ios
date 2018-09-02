//
//  FirstViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

final class FirstViewController: UIViewController{
  
  var didUpdateConstraint = false
  let titleLabel: UILabel = {
    let attributeString = NSMutableAttributedString(
      string: "입국심사에 오신걸 환영합니다.\n\n",
      attributes: [.foregroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),.font: UIFont.NotoSansKRBold(size: 20)])
    
    attributeString.append(NSAttributedString(
      string: "여행에 가치를 더하기 위해\n몇가지 질문을 드리겠습니다.",
      attributes: [.font : UIFont.NotoSansKRMedium(size: 15)]))
    
    let label = UILabel()
    label.attributedText = attributeString
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(titleLabel)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-100)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
