//
//  CharacterFooterView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import LGButton
import RxSwift
import RxCocoa

class CharacterFooterView: UICollectionReusableView{
  
  let commitButton: LGButton = {
    let button = LGButton()
    button.titleString = "등록하기"
    button.titleFontName = "BMJUAOTF"
    button.titleFontSize = 30
    button.cornerRadius = 10
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
      make.height.equalTo(40)
      make.width.equalTo(200)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
