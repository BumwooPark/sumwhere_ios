//
//  MainCollectionHeaderView.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class MainCollectionHeaderView: UICollectionReusableView{
  
  let titleLabel: UILabel = {
    let label = UILabel()
//    let attributedString = NSMutableAttributedString(string: "심재은님을 \n위한 갈래말래의 추천 여행지", attributes: [
//      .font: UIFont(name: "NanumSquareOTFB", size: 20.0)!,
//      .foregroundColor: UIColor(red: 6.0 / 255.0, green: 7.0 / 255.0, blue: 9.0 / 255.0, alpha: 1.0),
//      .kern: -0.56
//      ])
//    attributedString.addAttributes([
//      .font: UIFont.TextStyle,
//      .foregroundColor: UIColor(white: 105.0 / 255.0, alpha: 1.0)
//      ], range: NSRange(location: 0, length: 5))
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.centerY.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
