//
//  ProfileImageViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

final class ProfileImageViewController: UIViewController{
  var didUpdateConstraint = false
  let titleLabel: UILabel = {
    let attributeString = NSMutableAttributedString(
      string: "사진을 등록해 주세요\n\n",
      attributes: [.foregroundColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),.font: UIFont.NotoSansKRBold(size: 20)])
    attributeString.append(NSAttributedString(
      string: "사진 최소 2장이상",
      attributes: [.font: UIFont.NotoSansKRMedium(size: 15)]))
    let label = UILabel()
    label.attributedText = attributeString
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
        make.centerY.equalToSuperview().inset(-200)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
