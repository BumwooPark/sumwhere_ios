//
//  TripStyleFooterView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class TripStyleFooterView: UICollectionReusableView{
  
  let commitButton: UIButton = {
    let button = UIButton()
    button.setTitle("등록하기", for: .normal)
    button.backgroundColor = .blue
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
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
