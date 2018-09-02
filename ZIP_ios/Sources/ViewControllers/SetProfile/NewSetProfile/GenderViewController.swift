//
//  GenderViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

final class GenderViewController: UIViewController{
  
  var didUpdateConstraint = false
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "성별은 어떻게 되시나요?"
    label.font = UIFont.NotoSansKRBold(size: 20)
    label.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
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
        make.centerY.equalToSuperview().inset(-200)
        make.centerX.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
