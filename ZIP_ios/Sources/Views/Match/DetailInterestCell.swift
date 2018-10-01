//
//  DetailInterestCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import TagListView

class DetailInterestCell: UICollectionViewCell, MatchDataSavable{
  var item: UserTripJoinModel?{
    didSet{
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRBold(size: 20)
    label.text = "관심사"
    return label
  }()
  
  let tagView: TagListView = {
    let view = TagListView()
    view.alignment = .center
    view.addTags(["수영","드라이브","스포츠","패스티벌","쇼핑","박물관","걷기","명소","음식"])
    view.textColor = #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)
    view.tagBackgroundColor = .white
    view.textFont = UIFont.NotoSansKRMedium(size: 17)
    view.paddingX = 10
    view.paddingY = 10
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(titleLabel)
    addSubview(tagView)
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(20)
    }
    
    tagView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.left.bottom.right.equalToSuperview().inset(20)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
