//
//  TicketView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class TicketView: UIView{
  @IBOutlet weak var destinationLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var peopleCountLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 0.5
    self.layer.cornerRadius = 10
    self.layer.masksToBounds = true
  }
}
