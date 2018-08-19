//
//  CalendarCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 19..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import JTAppleCalendar

class CalendarCell: JTAppleCell {
  
  let selectView = UIView()
  
  let todayLabel: UILabel = {
    let label = UILabel()
    label.text = "오늘"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 8)
    return label
  }()
  
  override var isSelected: Bool{
    didSet{
      selectView.backgroundColor = isSelected ? #colorLiteral(red: 0.5212282456, green: 0.8123030511, blue: 1, alpha: 1) : .clear
    }
  }
  
  let dayLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRMedium(size: 17)
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(selectView)
    contentView.addSubview(dayLabel)
    dayLabel.addSubview(todayLabel)
    
    contentView.backgroundColor = .white
    
    dayLabel.font = UIFont.NotoSansKRMedium(size: 15)
    
    dayLabel.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    todayLabel.snp.makeConstraints { (make) in
      make.height.equalTo(10)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().inset(-5)
    }
    
    selectView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.height.width.equalTo(30)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    selectView.layer.cornerRadius = 15
    selectView.layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
