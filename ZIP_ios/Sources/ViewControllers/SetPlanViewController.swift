//
//  SetPlanViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit
import FSCalendar

class SetPlanViewController: UIViewController, UIGestureRecognizerDelegate{
  
  fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
    [unowned self] in
    let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
    panGesture.delegate = self
    panGesture.minimumNumberOfTouches = 1
    panGesture.maximumNumberOfTouches = 2
    return panGesture
    }()
  
  lazy var calendar: FSCalendar = {
    let view = FSCalendar()
    view.delegate = self
    view.dataSource = self
    view.allowsMultipleSelection = true
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(calendar)
    addConstraint()
  }
  
  private func addConstraint(){
    calendar.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(300)
    }
    self.view.layoutIfNeeded()
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

//  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//    let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
//    if shouldBegin {
//      let velocity = self.scopeGesture.velocity(in: self.view)
//      switch self.calendar.scope {
//      case .month:
//        return velocity.y < 0
//      case .week:
//        return velocity.y > 0
//      }
//    }
//    return shouldBegin
//  }
}

extension SetPlanViewController: FSCalendarDelegate{
  
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendar.snp.updateConstraints { (make) in
      make.height.equalTo(bounds.height)
    }
    self.view.layoutIfNeeded()
  }
}

extension SetPlanViewController: FSCalendarDataSource{
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    log.info(date)
    configureVisibleCells()
  }
  
  
  
}
