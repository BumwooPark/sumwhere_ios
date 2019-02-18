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
import SwiftDate
import EventKit
import MXParallaxHeader


final class InsertPlanViewController: UIViewController{
  let store = EKEventStore()
  private let disposeBag = DisposeBag()
  private var viewModel = PlanDateViewModel()
  private var didUpdateConstraint = false
  private let headerView = CalendarHeaderView.loadXib(nibName: "CalendarHeaderView") as! CalendarHeaderView
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.AppleSDGothicNeoSemiBold(size: 20)
    label.textColor = .black
    return label
  }()
  
  private let gregorian: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    return calendar
  }()
  
  private let completeButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoSemiBold(size: 22.8)
    button.setTitle("여행 등록", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    button.layer.cornerRadius = 11
    button.layer.masksToBounds = true
    button.isEnabled = false
    return button
  }()
  
  lazy var calendarView: JTAppleCalendarView = {
    let calendar = JTAppleCalendarView()
    calendar.backgroundColor = .white
    calendar.calendarDelegate = self
    calendar.minimumLineSpacing = 0
    calendar.minimumInteritemSpacing = 0
    calendar.calendarDataSource = self
    calendar.scrollingMode = .stopAtEachCalendarFrame
    calendar.scrollDirection = .vertical
    calendar.showsVerticalScrollIndicator = false
    calendar.allowsMultipleSelection = true
    calendar.isRangeSelectionUsed = true
    calendar.isPagingEnabled = false
    calendar.register(CalendarHeader.self, forSupplementaryViewOfKind: JTAppleCalendarView.elementKindSectionHeader, withReuseIdentifier: String(describing: CalendarHeader.self))
    calendar.register(CalendarCell.self, forCellWithReuseIdentifier: String(describing: CalendarCell.self))
    return calendar
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.backgroundColor = .white
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = .white
    self.navigationController?.navigationBar.backgroundColor = .white
    let height = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
    calendarView.parallaxHeader.minimumHeight = height + 100
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.backgroundColor = .clear
    setStatusBarBackgroundColor(color: .clear)
  }
  
  private func setStatusBarBackgroundColor(color: UIColor) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = color
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    _ = calendarView
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    view.addSubview(headerView)
    view.addSubview(calendarView)
    view.addSubview(completeButton)
    view.setNeedsUpdateConstraints()
    
    self.navigationController?.navigationBar.topItem?.title = String()
    
    bind()
  }
  
  
  private func bind(){
    completeButton.rx
      .tap
      .bind(onNext: viewModel.inputs.complete)
      .disposed(by: disposeBag)
    
    viewModel.outputs.selectedBinder
      .subscribeNext(weak: self) { (weakSelf) -> ((result: Bool, start: Date, end: Date)) -> Void in
        return {result in
          if result.result {
            let calendar = Calendar.current
            let date1 = calendar.startOfDay(for: result.start)
            let date2 = calendar.startOfDay(for: result.end)
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            let diffday = components.day ?? 0
            
            weakSelf.completeButton.setTitle("\(diffday)박 \(diffday + 1)일의 여행등록", for: .normal)
          }else{
            weakSelf.completeButton.setTitle("여행 등록", for: .normal)
          }
          
          weakSelf.completeButton.backgroundColor = result.result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
          weakSelf.completeButton.isEnabled = result.result ? true : false
        }
      }.disposed(by: disposeBag)
    
    
    viewModel.outputs.successSubmit
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in  
          weakSelf.navigationController?.pushViewController(InsertDetailScheduleViewController(), animated: true)
        }
    }.disposed(by: disposeBag)
    
    viewModel.outputs
      .titleBinder
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func deSelectDate(){
    self.calendarView.deselectAllDates(triggerSelectionDelegate: false)
    self.completeButton.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    self.completeButton.setTitle(String(), for: .normal)
    self.completeButton.isEnabled = false
  }
  
  func handleSelection(cell: JTAppleCell?, cellState: CellState) {
    let myCustomCell = cell as! CalendarCell // You created the cell view if you followed the tutorial
    myCustomCell.cellState = cellState
    cell?.setNeedsLayout()
    cell?.layoutIfNeeded()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(40)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
      }
      
      headerView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom)
        make.left.right.equalToSuperview()
        make.height.equalTo(40)
      }
      
      calendarView.snp.makeConstraints { (make) in
        make.top.equalTo(headerView.snp.bottom)
        make.left.right.equalToSuperview()
        make.bottom.equalTo(completeButton.snp.top)
      }
      
      completeButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        make.height.equalTo(50)
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
    deSelectDate()
  }
  
  func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
    let view = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: String(describing: CalendarHeader.self), for: indexPath) as! CalendarHeader
    
    view.startDate = range.start.dateByAdding(1,.day).date
    return view
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: CalendarCell.self), for: indexPath) as! CalendarCell
    
    cell.dayLabel.text = cellState.text
    cell.todayLabel.isHidden = !date.dateByAdding(1, .day).compare(.isToday)
    handleSelection(cell: cell, cellState: cellState)
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleSelection(cell: cell, cellState: cellState)
    viewModel.inputs.selectDate(calendar: calendar, date: date)
  }
  
  // 현제 날짜보다 이전선택 불가하도록
  func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
    return date >= Date()
  }
  
  func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
    return MonthSize(defaultSize: 40)
  }
}

//MARK: - JT DataSource
extension InsertPlanViewController: JTAppleCalendarViewDataSource{
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
    let parameters = ConfigurationParameters(startDate: Date(), endDate: gregorian.date(byAdding: .year, value: 1, to: Date())!, numberOfRows: 7, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
    
    return parameters
  }
}
