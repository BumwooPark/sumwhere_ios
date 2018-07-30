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
  var didUpdateConstraint = false
  lazy var provider = AuthManager.provider
  var commitAction: (() -> Void)?
  
  let viewController: UIViewController
  var dateCount = 0
  var firstDate: Date?{
    didSet{
      let vc = viewController as! CreateTravelViewController
      guard let date = firstDate else {return}
      vc.viewModel.dataSubject.onNext(.startDate(date: gregorian.date(byAdding: .day, value: 1, to: date)!))
    }
  }
  var lastDate: Date?{
    didSet{
      if lastDate == nil{
        totalLabel.text = ""
      }else{
        let totalday = (lastDate?.day ?? 0)  - (firstDate?.day ?? 0)
        let vc = viewController as! CreateTravelViewController
        totalLabel.text = "\(totalday)박 \(totalday + 1)일"
        guard let date = lastDate else {return}
        vc.viewModel.dataSubject.onNext(.endDate(date: gregorian.date(byAdding: .day, value: 1, to: date)!))
      }
    }
  }
  
  fileprivate let gregorian: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    return calendar
  }()
  
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
    calendar.register(CodeCellView.self, forCellWithReuseIdentifier: "code")
    return calendar
  }()
  
  let totalLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.BMJUA(size: 16)
    label.textAlignment = .center
    return label
  }()

  fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY년MM월dd일"
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
  }()
  
  let monthLabel: LTMorphingLabel = {
    let label = LTMorphingLabel()
    label.textAlignment = .center
    label.font = UIFont.BMJUA(size: 19)
    return label
  }()

  init(viewController: UIViewController) {
    self.viewController = viewController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(calendarView)
    view.addSubview(monthLabel)
    view.addSubview(totalLabel)
  
    
    let month = Calendar.current.dateComponents([.month], from: Date()).month!
    let year = Calendar.current.component(.year, from: Date())
    monthLabel.text = String(year) + " " + String(month) + "월"
    
    view.setNeedsUpdateConstraints()
  }
  
  func handleSelection(cell: JTAppleCell?, cellState: CellState) {
    let myCustomCell = cell as! CodeCellView // You created the cell view if you followed the tutorial

    log.info(cellState.selectedPosition())
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
      
      monthLabel.snp.makeConstraints { (make) in
        make.centerX.top.equalToSuperview()
        make.height.equalTo(50)
      }
      
      calendarView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview()
        make.top.equalTo(monthLabel.snp.bottom)
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

class CodeCellView: JTAppleCell {
  
  let selectView = UIView()
  
  override var isSelected: Bool{
    didSet{
      selectView.backgroundColor = isSelected ? #colorLiteral(red: 0.5212282456, green: 0.8123030511, blue: 1, alpha: 1) : .clear
    }
  }
  
  let dayLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.BMJUA(size: 17)
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(selectView)
    contentView.addSubview(dayLabel)
    
    contentView.backgroundColor = .white
    
    dayLabel.font = UIFont.BMJUA(size: 15)
    
    dayLabel.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
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

extension InsertPlanViewController: JTAppleCalendarViewDelegate{
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    handleSelection(cell: cell, cellState: cellState)
//    log.info("\(date) \(cellState.selectedPosition())")
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    calendarView.deselectAllDates(triggerSelectionDelegate: false)
    firstDate = nil
    lastDate = nil
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "code", for: indexPath) as! CodeCellView
    cell.dayLabel.textColor = (cellState.dateBelongsTo == .thisMonth) ? .black : .gray
    cell.dayLabel.text = cellState.text
    
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    
    
    if firstDate != nil && lastDate == nil {
      
      if firstDate!.day > date.day{
        calendarView.deselectAllDates(triggerSelectionDelegate: false)
        firstDate = date
        cell?.isSelected = true
        return
      }
      
      calendarView.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
      lastDate = date
    } else if firstDate == nil && lastDate == nil{
      firstDate = date
    }else if firstDate != nil && lastDate != nil {
      firstDate = nil
      lastDate = nil
      calendarView.deselectAllDates(triggerSelectionDelegate: false)
    }
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    guard let startDate = visibleDates.monthDates.first?.date else {
      return
    }
    
    let month = Calendar.current.dateComponents([.month], from: startDate).month!
    let year = Calendar.current.component(.year, from: startDate)
    monthLabel.text = String(year) + " " + String(month) + "월"
  }
}

extension InsertPlanViewController: JTAppleCalendarViewDataSource{
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
    let parameters = ConfigurationParameters(startDate: Date(), endDate: gregorian.date(byAdding: .year, value: 1, to: Date())!, numberOfRows: 7, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
    
    return parameters
  }
}
