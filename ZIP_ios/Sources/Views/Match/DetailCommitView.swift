//
//  DetailCommitView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class DetailCommitView: UICollectionReusableView{
  
  private let commitButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)
    button.setTitle("동행 신청", for: .normal)
    button.layer.cornerRadius = 10
    button.layer.masksToBounds = true
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(commitButton)
    commitButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
