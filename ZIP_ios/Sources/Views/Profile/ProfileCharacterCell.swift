//
//  ProfileCharacterCell.swift
//  ZIP_ios
//
//  Created by xiilab on 21/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit
import TagListView

class ProfileCharacterCell: UICollectionViewCell{
  private var didUpdateConstraint = false
 
  private let tagView: TagListView = {
    let tagView = TagListView()
    tagView.addTags(["차분한","차분한","차분한","차분한"])
    tagView.alignment = .center
    tagView.cornerRadius = 15
    tagView.borderColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    tagView.borderWidth = 1.5
    tagView.tagBackgroundColor = .white
    
    tagView.textColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    tagView.marginX = 5
    tagView.marginY = 5
    tagView.paddingY = 10
    tagView.paddingX = 10
    tagView.textFont = .AppleSDGothicNeoSemiBold(size: 13.1)
    return tagView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(tagView)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      tagView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      tagView.sizeToFit()
      log.info(tagView.intrinsicContentSize)
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


