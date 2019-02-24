//
//  ProfileSubmitButtonView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 25/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit

class ProfileSubmitButtonView: UIView {
  var didUpdateConstraint = false
  let button: UIButton = {
    let button = UIButton()
    button.setTitle("동행신청", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    button.layer.cornerRadius = 5
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(button)
    needsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      button.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
