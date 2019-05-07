//
//  searchView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 07/05/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

final class SearchButton: UIButton{
  var didUpdateConstraint = false
  let btnImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "searchBtn.png")
    return imageView
  }()
  
  let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    return view
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(btnImage)
    addSubview(bottomView)
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    
    if !didUpdateConstraint{
      
      btnImage.snp.makeConstraints { (make) in
        make.left.top.equalToSuperview()
        make.width.equalTo(20)
        make.height.equalTo(19)
      }
      
      bottomView.snp.makeConstraints { (make) in
        make.right.bottom.left.equalToSuperview()
        make.height.equalTo(1)
      }
      
      
      didUpdateConstraint = true
    }
    
    super.updateConstraints()
  }
}
