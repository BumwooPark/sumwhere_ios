//
//  InsertPlanViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 25..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Moya
import JTAppleCalendar
import LTMorphingLabel
import SwiftDate

final class InsertPlanViewController: UIViewController{

  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  private let viewController: CreateTripViewController
  private let headerView = CalendarHeaderView.loadXib(nibName: "CalendarHeaderView") as! CalendarHeaderView
  private let gregorian: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    return calendar
  }()
  
  private let totalLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NotoSansKRMedium(size: 16)
    label.textAlignment = .center
    return label
  }()
  
  var firstDate: Date?{
    didSet{
      if firstDate == nil{
        viewController.viewModel.dataSubject.onNext(.startDate(date: Date()))
      }else{
        guard let date = firstDate else {return}
        viewController.viewModel.dataSubject.onNext(.startDate(date: date + 1.days))
      }
    }
  }
  
  var lastDate: Date?{
    didSet{
      if lastDate == nil{
        viewController.viewModel.dataSubject.onNext(.endDate(date: Date()))
        totalLabel.text = ""
      }else{
        let totalday = (lastDate?.day ?? 0)  - (firstDate?.day ?? 0)
        totalLabel.text = "\(totalday)박 \(totalday + 1)일"
        guard let date = lastDate else {return}
        viewController.viewModel.dataSubject.onNext(.endDate(date: date + 1.days))
      }
    }
  }
  
  var startDate: Date?
  var endDate: Date?
  var fullCount = 0

 
  lazy var calendarView: JTAppleCalendarView = {
    let calendar = JTAppleCalendarView()
    calendar.backgroundColor = .white
    calendar.calendarDelegate = self
    calendar.calendarDataSource = self
    calendar.scrollingMode = .stopAtEachCalendarFrame
    calendar.scrollDirection = .vertical
    calendar.showsVerticalScrollIndicator = false
    calendar.allowsMultipleSelection = true
    calendar.isRangeSelectionUsed = true
    calendar.register(CalendarCell.self, forCellWithReuseIdentifier: String(describing: CalendarCell.self))
    return calendar
  }()

  init(viewController: CreateTripViewController) {
    self.viewController = viewController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(headerView)
    view.addSubview(calendarView)
    view.addSubview(totalLabel)
  
    let month = Calendar.current.dateComponents([.month], from: Date()).month!
    let year = Calendar.current.component(.year, from: Date())
    headerView.monthLabel.text = String(year) + " " + String(month) + "월"
    
    view.setNeedsUpdateConstraints()
  }
  
  func handleSelection(cell: JTAppleCell?, cellState: CellState) {
    let myCustomCell = cell as! CalendarCell // You created the cell view if you followed the tutorial
    
    switch cellState.selectedPosition() {
    case .full, .left, .right:
      myCustomCell.selectView.isHidden = false
      myCustomCell.selectView.backgroundColor = #colorLiteral(red: 0.5212282456, green: 0.8123030511, blue: 1, alpha: 1) // Or you can put what ever you like for your rounded corners, and your stand-alone selected cell
    case .middle:
      myCustomCell.selectView.isHidden = false
      myCustomCell.selectView.backgroundColor = #colorLiteral(red: 0.5212282456, green: 0.8123030511, blue: 1, alpha: 0.4978268046) // Or what ever you want for your dates that land in the middle
    default:
      break
    }
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      headerView.snp.makeConstraints { (make) in
        make.left.top.right.equalToSuperview()
        make.height.equalTo(100)
      }
      
      calendarView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview()
        make.top.equalTo(headerView.snp.bottom)
        make.bottom.equalToSuperview().inset(70)
      }
      
      totalLabel.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.top.equalTo(calendarView.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}


//MARK: - JT Delegate
extension InsertPlanViewController: JTAppleCalendarViewDelegate{
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    handleSelection(cell: cell, cellState: cellState)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleSelection(cell: cell, cellState: cellState)
    calendarView.deselectAllDates(triggerSelectionDelegate: false)
    startDate = nil
    viewController.viewModel.dataSubject.onNext(.startDate(date: Date() + 1.days))
    viewController.viewModel.dataSubject.onNext(.endDate(date: Date() + 1.days))
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: CalendarCell.self), for: indexPath) as! CalendarCell
    cell.dayLabel.textColor = (cellState.dateBelongsTo == .thisMonth) ? .black : .gray
    cell.dayLabel.text = cellState.text
    cell.todayLabel.isHidden = !date.compare(.isToday)
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    
    handleSelection(cell: cell, cellState: cellState)
    if startDate != nil {
      calendarView.selectDates(from: startDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
      viewController.viewModel.dataSubject.onNext(.startDate(date: startDate! + 1.days))
      viewController.viewModel.dataSubject.onNext(.endDate(date: date + 1.days))
    }else{
      startDate = date
    }
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    guard let startDate = visibleDates.monthDates.first?.date else {
      return
    }
    
    let month = Calendar.current.dateComponents([.month], from: startDate).month!
    let year = Calendar.current.component(.year, from: startDate)
    headerView.monthLabel.text = String(year) + " " + String(month) + "월"
  }
  
  // 현제 날짜보다 이전선택 불가하도록
  func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
    return date >= Date()
  }
}


//MARK: - JT DataSource
extension InsertPlanViewController: JTAppleCalendarViewDataSource{
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
    let parameters = ConfigurationParameters(startDate: Date(), endDate: gregorian.date(byAdding: .year, value: 1, to: Date())!, numberOfRows: 7, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
    
    return parameters
  }
}
