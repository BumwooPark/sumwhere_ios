//
//  DetailCharacterCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class DetailCharacterCell: UICollectionViewCell, MatchDataSavable{
  var item: UserTripJoinModel?{
    didSet{
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRBold(size: 20)
    label.text = "성격"
    return label
  }()
  
  private let characterLabel: UILabel = {
    let label = UILabel()
    let attributeString = NSMutableAttributedString(string: "소심한, 착한 ", attributes: [.font: UIFont.NotoSansKRMedium(size: 30),.foregroundColor: #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)])
    attributeString.append(NSAttributedString(string: "성격 입니다.", attributes: [.font: UIFont.NotoSansKRMedium(size: 30)]))
    label.attributedText = attributeString
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(titleLabel)
    addSubview(characterLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(20)
    }
    characterLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
