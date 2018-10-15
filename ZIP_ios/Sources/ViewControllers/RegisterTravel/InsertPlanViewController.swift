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


class DateControl{
  var startDate: Date = Date()
  var endDate: Date = Date()
  var selectCount = 0{
    didSet{
      if selectCount == 2{
        selectSubject.onNext(true)
      }else{
        selectSubject.onNext(false)
      }
    }
  }
  var selectSubject = PublishSubject<Bool>()
  private func deSelectAndSelect(calendar: JTAppleCalendarView ,date: Date){
    calendar.deselectAllDates(triggerSelectionDelegate: false)
    calendar.selectDates([date], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
  }
  
  func selectHandler(calendar: JTAppleCalendarView, date: Date) {
    switch selectCount{
    case 0:
      self.selectCount += 1
      self.startDate = date
    case 1:
      self.selectCount += 1
      self.endDate = date
      
      if date <= self.startDate {
        self.deSelectAndSelect(calendar: calendar, date: date)
        self.startDate = date
        self.selectCount = 1
      }else{
        calendar.selectDates(from: startDate, to: self.endDate,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
      }
    case 2:
      if date > self.endDate {
        self.deSelectAndSelect(calendar: calendar, date: date)
        self.selectCount = 1
        self.startDate = date
      }else{
        self.deSelectAndSelect(calendar: calendar, date: date)
        self.selectCount = 1
        self.startDate = date
        self.endDate = Date()
      }
    default:
      break
    }
  }
  
  func deSelectHandler(calendar: JTAppleCalendarView, date: Date) {
  }
}

final class InsertPlanViewController: UIViewController{

  private let disposeBag = DisposeBag()
  private let viewModel: RegisterTripViewModel
  private var didUpdateConstraint = false
  private let headerView = CalendarHeaderView.loadXib(nibName: "CalendarHeaderView") as! CalendarHeaderView
  private let dateControl = DateControl()
  
  private let dismissButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "imagecancel.png").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "여행일정을\n등록해주세요."
    label.numberOfLines = 0
    label.font = .AppleSDGothicNeoBold(size: 27)
    label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    return label
  }()
  
  private let gregorian: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    return calendar
  }()
  
  private let completeButton: UIButton = {
    let button = UIButton()
    button.setTitle("여행등록", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoSemiBold(size: 22.8)
    button.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    button.layer.cornerRadius = 11
    button.layer.masksToBounds = true
    button.isEnabled = false
    return button
  }()
  private let totalLabel: UILabel = {
    let label = UILabel()
//    label.font = UIFont.NotoSansKRMedium(size: 16)
    label.font = UIFont.init(name: "AppleSDGothicNeo-Bold", size: 16)
    label.textAlignment = .center
    return label
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
    calendar.register(CalendarCell.self, forCellWithReuseIdentifier: String(describing: CalendarCell.self))
    return calendar
  }()

  init(viewModel: RegisterTripViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    view.addSubview(headerView)
    view.addSubview(calendarView)
    view.addSubview(completeButton)
    view.addSubview(dismissButton)
  
    let month = Calendar.current.dateComponents([.month], from: Date()).month!
    let year = Calendar.current.component(.year, from: Date())
    headerViewLabelMapper(year: year, month: month)
    view.setNeedsUpdateConstraints()
    
    dismissButton.rx.tap
      .bind(to: viewModel.dismissAction)
      .disposed(by: disposeBag)
    
    completeButton.rx.tap
      .bind(to: viewModel.completeAction)
      .disposed(by: disposeBag)
    
    dateControl
      .selectSubject
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return { result in
          weakSelf.completeButton.backgroundColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
          weakSelf.completeButton.isEnabled = result ? true : false
        }
      }.disposed(by: disposeBag)
  }
  
  
  private func headerViewLabelMapper(year: Int, month: Int) {
    headerView.monthLabel.text = "  \(month)월"
    headerView.yearLabel.text = "   \(year)"
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
        make.left.equalToSuperview().inset(32)
        make.top.equalToSuperview().inset(93)
      }
      
      headerView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(30)
        make.top.equalTo(titleLabel.snp.bottom).offset(29)
        make.height.equalTo(100)
      }
      
      calendarView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(30)
        make.top.equalTo(headerView.snp.bottom)
        make.height.equalTo(calendarView.snp.width)
      }
      
      completeButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalToSuperview().inset(10)
        make.height.equalTo(50)
      }
      
      dismissButton.snp.makeConstraints { (make) in
        make.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(27)
        make.width.height.equalTo(18)
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
    dateControl.deSelectHandler(calendar: calendar, date: date)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: CalendarCell.self), for: indexPath) as! CalendarCell
    cell.dayLabel.textColor = (cellState.dateBelongsTo == .thisMonth) ? #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    cell.dayLabel.text = cellState.text
    cell.todayLabel.isHidden = !date.compare(.isToday)
    handleSelection(cell: cell, cellState: cellState)
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleSelection(cell: cell, cellState: cellState)
    dateControl.selectHandler(calendar: calendar,date: date)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    guard let startDate = visibleDates.monthDates.first?.date else {
      return
    }
    
    let month = Calendar.current.dateComponents([.month], from: startDate).month!
    let year = Calendar.current.component(.year, from: startDate)
    headerViewLabelMapper(year: year, month: month)
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
