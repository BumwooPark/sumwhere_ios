//
//  TagRow.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


import Eureka
import TagListView

public class TagCell: Cell<String>, CellType, TagListViewDelegate{
  
  public lazy var tagListView: TagListView = {
    let view = TagListView()
    view.alignment = .center
    view.textFont = UIFont.NotoSansKRMedium(size: 14)
    view.cornerRadius = 5
    view.tagBackgroundColor = .gray
    view.paddingY = 5
    view.paddingX = 12
    view.marginY = 5
    view.marginX = 7
    view.delegate = self
    return view
  }()
  
  public override func setup() {
    super.setup()
    addSubview(tagListView)
    height = {UITableView.automaticDimension}
    selectionStyle = .none
    tagListView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
  }
  
  public func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
    if tagView.isSelected{
      tagView.isSelected = false
      tagView.tagBackgroundColor = .gray
    }else{
      tagView.isSelected = true
      tagView.tagBackgroundColor = .blue
    }
  }
}


public final class TagRow: Row<TagCell>, RowType{
  public required init(tag: String?) {
    super.init(tag: tag)
    cellProvider = CellProvider<TagCell>()
  }
}
