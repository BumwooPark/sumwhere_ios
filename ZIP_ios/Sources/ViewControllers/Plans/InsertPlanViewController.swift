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

final class InsertPlanViewController: UIViewController{

  let disposeBag = DisposeBag()
  lazy var provider = AuthManager.provider
  var commitAction: (() -> Void)?
  
  lazy var calendar: JTAppleCalendarView = {
    let calendar = JTAppleCalendarView()
    calendar.backgroundColor = .white
    calendar.calendarDelegate = self
    calendar.calendarDataSource = self
    calendar.scrollingMode = .stopAtEachCalendarFrame
    calendar.scrollDirection = .horizontal
    calendar.showsHorizontalScrollIndicator = false
    calendar.register(CodeCellView.self, forCellWithReuseIdentifier: "code")
    return calendar
  }()

  fileprivate let gregorian: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    return calendar
  }()
  
  fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY년MM월dd일"
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
  }()
  
  private let commitButton: UIButton = {
    let button = UIButton()
    button.setTitle("commit", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    return button
  }()
  
  private let dismissButton: UIButton = {
    let button = UIButton()
    button.setTitle("dismiss", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    return button
  }()
  
  let monthLabel: LTMorphingLabel = {
    let label = LTMorphingLabel()
    label.textAlignment = .center
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    view.addSubview(calendar)
    view.addSubview(monthLabel)
    view.addSubview(commitButton)
    view.addSubview(dismissButton)
    
    dismissButton.rx.tap
      .subscribe {[weak self] (_) in
        self?.dismiss(animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    commitButton.rx.tap
      .subscribe {[weak self] (_) in
        self?.dismiss(animated: true, completion: {[weak self] in
          guard let `self` = self, let action = self.commitAction  else {return}
          action()
        })
      }.disposed(by:disposeBag)
    

    addConstraint()
  }
  
  private func addConstraint(){
    calendar.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.height.equalTo(300)
      make.width.equalTo(300)
    }
    
    monthLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(calendar.snp.top)
      make.left.right.equalTo(calendar)
      make.height.equalTo(50)
    }
    
    commitButton.snp.makeConstraints { (make) in
      make.top.equalTo(calendar.snp.bottom)
      make.left.equalTo(calendar)
      make.right.equalTo(calendar.snp.centerX)
      make.height.equalTo(50)
    }
    
    dismissButton.snp.makeConstraints { (make) in
      make.left.equalTo(commitButton.snp.right)
      make.right.equalTo(calendar)
      make.height.top.equalTo(commitButton)
    }
  }

}

class CodeCellView: JTAppleCell {
  let bgColor = UIColor.red
  
  let dayLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(dayLabel)
    contentView.backgroundColor = .white
    
    dayLabel.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func draw(_ rect: CGRect) {
//    let context = UIGraphicsGetCurrentContext()
//    context?.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
//    let r1 = CGRect(x: 0, y: 0, width: 25, height: 25)
//    context?.addRect(r1)
//    context?.fillPath()
//    context?.setStrokeColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0)
//    context?.addEllipse(in: CGRect(x: 0, y: 0, width: 25, height: 25))
//    context?.strokePath()
  }
}



extension InsertPlanViewController: JTAppleCalendarViewDelegate{
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "code", for: indexPath) as! CodeCellView
    cell.dayLabel.textColor = (cellState.dateBelongsTo == .thisMonth) ? .black : .gray
    cell.dayLabel.text = cellState.text
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    log.info(gregorian.date(byAdding: .day, value: 1, to: date))
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
