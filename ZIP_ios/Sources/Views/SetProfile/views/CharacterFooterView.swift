//
//  CharacterFooterView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import LGButton

class CharacterFooterView: UICollectionReusableView{
  
  let commitButton: LGButton = {
    let button = LGButton()
    button.titleString = "등록하기"
    button.titleFontName = "BMJUAOTF"
    button.titleFontSize = 30
    button.cornerRadius = 10
    return button
  }()
  
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
