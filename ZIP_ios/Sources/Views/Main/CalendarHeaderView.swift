//
//  CalendarHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 19..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import LTMorphingLabel

class CalendarHeaderView: UIView {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var monthLabel: LTMorphingLabel!
  @IBOutlet weak var yearLabel: LTMorphingLabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLabel.numberOfLines = 0
  }
}
