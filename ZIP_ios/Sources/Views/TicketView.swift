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
  
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var endButton: UIButton!
  @IBOutlet weak var peopleButton: UIButton!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
