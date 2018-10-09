//
//  CalendarCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 19..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import JTAppleCalendar

class CalendarCell: JTAppleCell {
  
  var cellState: SelectionRangePosition? {
    didSet{
      
      layoutOfCellState(cellState: cellState!)
      switch cellState!{
      case .left,.right:
        selectView.isHidden = false
        selectSqureView.isHidden = false
        dayLabel.textColor = .white
      case .full:
        selectView.isHidden = false
        selectSqureView.isHidden = true
        dayLabel.textColor = .white
      case .middle:
        selectView.isHidden = true
        selectSqureView.isHidden = false
        dayLabel.textColor = .white
      case .none:
        selectView.isHidden = true
        selectSqureView.isHidden = true
        dayLabel.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
      }
    }
  }
  
  let selectView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    view.isHidden = true
    return view
  }()
  
  let selectSqureView: UIView = {
    let view = UIView()
//    view.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    view.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    view.isHidden = true
    return view
  }()
  
  let todayLabel: UILabel = {
    let label = UILabel()
    label.text = "오늘"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 8)
    return label
  }()
  
  let dayLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoSemiBold(size: 17.8)
    label.textAlignment = .center
    return label
  }()
  
  
  private func layoutOfCellState(cellState: SelectionRangePosition){
    switch cellState{
    case .left:
      selectSqureView.snp.remakeConstraints { (make) in
        make.right.equalToSuperview()
        make.left.equalTo(selectView.snp.centerX)
        make.top.equalTo(selectView)
        make.bottom.equalTo(selectView)
      }
    case .right:
      selectSqureView.snp.remakeConstraints { (make) in
        make.right.equalTo(selectView.snp.centerX)
        make.left.equalToSuperview()
        make.top.equalTo(selectView)
        make.bottom.equalTo(selectView)
      }
    default:
      selectSqureView.snp.remakeConstraints { (make) in
        make.center.equalToSuperview()
        make.height.width.equalTo(self.contentView.snp.width)
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(selectSqureView)
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
      make.height.width.equalTo(self.contentView.snp.width)
    }
    
    selectSqureView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.height.width.equalTo(self.contentView.snp.width)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    selectView.layer.cornerRadius = selectView.frame.width/2
    selectView.layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
