//
//  TripStyleFooterView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import LGButton

class TripStyleFooterView: UICollectionReusableView{
  
  let commitButton: LGButton = {
    let button = LGButton()
    button.bgColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    button.titleString = "등록하기"
    button.titleFontName = "NotoSansKR-Medium"
    button.titleFontSize = 30
    button.cornerRadius = 5
    return button
  }()
  
  lazy var commitAction = commitButton.rx
    .controlEvent(.touchUpInside)
    .map{_ in return ()}
    .share()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(commitButton)
    
    commitButton.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.height.equalTo(50)
      make.width.equalTo(200)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
