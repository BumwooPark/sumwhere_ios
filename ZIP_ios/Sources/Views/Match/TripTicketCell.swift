//
//  TripTicketCell.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 10..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class TripTicketCell: UICollectionViewCell{
  
  var didUpdateConstraint = false
  let ticketView = TicketView.loadXib(nibName: "TicketView") as! TicketView
  
  var item: TripModel?{
    didSet{
      ticketView.startLabel.text = String((item?.trip.startDate ?? String()).prefix(10))
      ticketView.endLabel.text = String((item?.trip.endDate ?? String()).prefix(10))
      ticketView.countryLabel.text = item?.tripType.country
      ticketView.destinationLabel.text = item?.tripType.trip
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(ticketView)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      ticketView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = false
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
