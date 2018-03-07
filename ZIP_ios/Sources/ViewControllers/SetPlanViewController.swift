//
//  SetPlanViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit
import FSCalendar

class SetDateViewController: UIViewController{
  

  fileprivate var calendar: FSCalendar!
  fileprivate let gregorian = Calendar(identifier: .gregorian)
  override func loadView() {
    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = UIColor.groupTableViewBackground
    self.view = view
    
    let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
    let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: self.view.bounds.width, height: height))
    calendar.dataSource = self
    calendar.delegate = self
    calendar.backgroundColor = UIColor.white
    calendar.allowsMultipleSelection = true
    calendar.appearance.headerDateFormat = "YYYY년 MM월"
    calendar.appearance.caseOptions = [.weekdayUsesUpperCase,.weekdayUsesSingleUpperCase]
    calendar.locale = Locale.current
    calendar.calendarHeaderView.calendar.locale = Locale(identifier: "ko_KR")
    calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: String(describing: DIYCalendarCell.self))
    self.view.addSubview(calendar)
    self.calendar = calendar
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  private func configureVisibleCells() {
    calendar.visibleCells().forEach { (cell) in
      let date = calendar.date(for: cell)
      let position = calendar.monthPosition(for: cell)
      self.configure(cell: cell, for: date!, at: position)
    }
  }
  private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition){
    
  }
}

extension SetDateViewController: FSCalendarDelegate{
  
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendar.snp.updateConstraints { (make) in
      make.height.equalTo(bounds.height)
    }
    self.view.layoutIfNeeded()
  }
}

extension SetDateViewController: FSCalendarDataSource{
//  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//    log.info(date)
//    configureVisibleCells()
//  }
  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: String(describing: DIYCalendarCell.self), for: date, at: position)
    return cell
  }
  
  func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    if monthPosition == .previous || monthPosition == .next {
      calendar.setCurrentPage(date, animated: true)
    }
    log.info(date)
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    if monthPosition == .previous || monthPosition == .next {
      calendar.setCurrentPage(date, animated: true)
    }
  }
  func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    if self.gregorian.isDateInToday(date) {
      return "오늘"
    }
    return nil
  }
  
  func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    if self.gregorian.isDateInToday(date) {
      return "오늘"
    }
    return nil
  }
}

class DIYCalendarCell: FSCalendarCell{
  override init!(frame: CGRect) {
    super.init(frame: frame)
    self.titleLabel.text = "선택!!"
  }
  
  required init!(coder aDecoder: NSCoder!) {
    fatalError("init(coder:) has not been implemented")
  }
}
