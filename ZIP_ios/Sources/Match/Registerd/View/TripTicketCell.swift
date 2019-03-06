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
//      ticketView.startButton.setTitle(String((item?.trip.startDate ?? String()).prefix(10)), for: .normal)
//      ticketView.endButton.setTitle(String((item?.trip.endDate ?? String()).prefix(10)), for: .normal)
      ticketView.countryLabel.text = item?.tripPlace.trip
      ticketView.destinationLabel.text = item?.tripPlace.trip
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(ticketView)
    contentView.layer.shadowColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
    contentView.layer.shadowOpacity = 0.5
    contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
    contentView.layer.borderWidth = 0.5
    contentView.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
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
