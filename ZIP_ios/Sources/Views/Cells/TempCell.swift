//
//  TempCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 15..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


class TempCell: UITableViewCell{
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .gray
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
