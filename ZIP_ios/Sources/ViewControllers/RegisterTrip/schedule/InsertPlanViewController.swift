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

class DateControl{
  
  var startDate: Date = Date()
  var endDate: Date = Date()
  var selectCount = 0
  var selectSubject = PublishSubject<(result:Bool,start:Date?,end: Date?)>()
  private func deSelectAndSelect(calendar: JTAppleCalendarView ,date: Date){
    calendar.deselectAllDates(triggerSelectionDelegate: false)
    calendar.selectDates([date], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
  }

  func selectHandler(calendar: JTAppleCalendarView, date: Date) {
    switch selectCount{
    case 0:
      self.selectCount += 1
      self.startDate = date
      selectSubject.onNext((false,nil,nil))
    case 1:
      self.selectCount += 1
      self.endDate = date
      
      if date <= self.startDate {
        self.deSelectAndSelect(calendar: calendar, date: date)
        self.startDate = date
        self.selectCount = 1
      }else{
        selectSubject.onNext((true,start: startDate,end: self.endDate))
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
      selectSubject.onNext((false,nil,nil))
    default:
      selectSubject.onNext((false,nil,nil))
      break
    }
  }
  
  func deSelectHandler(calendar: JTAppleCalendarView, date: Date) {
  }
}

final class InsertPlanViewController: UIViewController{
  let store = EKEventStore()
  private let disposeBag = DisposeBag()
  private var viewModel: RegisterTripViewModel
  private var didUpdateConstraint = false
  private let headerView = CalendarHeaderView.loadXib(nibName: "CalendarHeaderView") as! CalendarHeaderView
  private let dateControl = DateControl()
  lazy var registerVC = RegisterViewController(viewModel: viewModel)
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
    let height = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
    calendarView.parallaxHeader.minimumHeight = height + 100
  }

  init(viewModel: RegisterTripViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    _ = registerVC.view
    viewModel.saver
      .subscribeNext(weak: self) { (weakSelf) -> (RegisterTripViewModel.SaveType) -> Void in
        return {type in
          switch type{
          case .place(let model):
            weakSelf.headerView.titleLabel.text = model.trip + "\n언제 떠날까요?"
          default:
            break
          }
        }
      }.disposed(by: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    view.addSubview(headerView)
    view.addSubview(calendarView)
    view.addSubview(completeButton)
    view.setNeedsUpdateConstraints()
    
    
    
    self.navigationController?.navigationBar.topItem?.title = String()
    completeButton.rx.tap
      .subscribeNext(weak: self){ (weakSelf) -> (()) -> Void in
        return { _ in
          weakSelf.navigationController?.pushViewController(weakSelf.registerVC, animated: true)
        }
      }.disposed(by: disposeBag)
    
    dateControl
      .selectSubject
      .subscribeNext(weak: self, { (weakSelf) -> ((result: Bool, start: Date?, end: Date?)) -> Void in
        return {result in
          if result.result {
            
            let calendar = Calendar.current
            let date1 = calendar.startOfDay(for: result.start ?? Date())
            let date2 = calendar.startOfDay(for: result.end ?? Date())
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            let diffday = components.day ?? 0
            
            weakSelf.viewModel.saver.accept(
              RegisterTripViewModel.SaveType.date(start: result.start?.dateByAdding(1, .day).date ?? Date(),
                                                  end: result.end?.dateByAdding(1, .day).date ?? Date()))
            
            weakSelf.completeButton.setTitle("\(diffday)박 \(diffday + 1)일의 여행등록", for: .normal)
          }else{
            weakSelf.completeButton.setTitle("여행 등록", for: .normal)
          }
          
          weakSelf.completeButton.backgroundColor = result.result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
          weakSelf.completeButton.isEnabled = result.result ? true : false
        }
      }).disposed(by: disposeBag)
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
      
      headerView.snp.makeConstraints { (make) in
        make.top.left.right.equalToSuperview()
        make.height.equalTo(250)
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
    dateControl.deSelectHandler(calendar: calendar, date: date)
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
    dateControl.selectHandler(calendar: calendar,date: date)
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
