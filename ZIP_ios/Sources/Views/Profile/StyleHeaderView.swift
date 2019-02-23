//
//  StyleHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 23/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

class StyleHeaderView: UICollectionReusableView{
  let titleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconPlace.png"), for: .normal)
    button.setTitle("# 선호하는 장소", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 14.4)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleButton)
    titleButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(52)
      make.centerY.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
