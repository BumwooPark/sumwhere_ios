//
//  MainCollectionFooterView.swift
//  ZIP_ios
//
//  Created by xiilab on 05/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

class MainCollectionFooterView: UICollectionReusableView{
  
  let footerview = MainFooterView.loadXib(nibName: "MainFooterView") as! MainFooterView
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(footerview)
    footerview.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
