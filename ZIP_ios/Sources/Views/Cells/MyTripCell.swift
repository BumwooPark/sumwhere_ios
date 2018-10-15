//
//  MyTripCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 1..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class MyTripCell: UITableViewCell{
  
  var didUpdateConstraint = false
  let ticketView = TicketView.loadXib(nibName: "TicketView") as! TicketView
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(ticketView)
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      contentView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
}
