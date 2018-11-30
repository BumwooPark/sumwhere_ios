//
//  CalendarHeader.swift
//  ZIP_ios
//
//  Created by xiilab on 30/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import JTAppleCalendar
import SnapKit

class CalendarHeader: JTAppleCollectionReusableView{
  var startDate: Date?{
    didSet{
      guard let date = startDate else {return}
      weekHeaderLayout(startWeek: date.weekday)
      let attributeString = NSMutableAttributedString(string: "\(date.month)월 ", attributes: [.font: UIFont.AppleSDGothicNeoBold(size: 24.2),.foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)])
      attributeString.append(NSAttributedString(string: "\(date.year)", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 15.8),.foregroundColor: #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)]))
      yearMonthLabel.attributedText = attributeString
    }
  }
  
  var didUpdateConstraint = false
  
  private let yearMonthLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  var constraint: Constraint?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(yearMonthLabel)
    setNeedsUpdateConstraints()
  }
  
  func weekHeaderLayout(startWeek: Int){
    let cellSize = (UIScreen.main.bounds.width - 60)/7
    if startWeek < 6{
      constraint?.update(inset: (cellSize * CGFloat(startWeek-1)))
    }else {
      constraint?.update(inset: (cellSize * CGFloat(6)))
    }
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      yearMonthLabel.snp.makeConstraints { (make) in
        constraint = make.left.equalToSuperview().inset(20).constraint
        make.centerY.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
