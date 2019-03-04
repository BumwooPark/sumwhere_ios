//
//  ActivityIndicator + Extension.swift
//  ZIP_ios
//
//  Created by xiilab on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import NVActivityIndicatorView


extension NVActivityIndicatorPresenter{
  func sumwhereStart(){
    let activityData = ActivityData(size: CGSize(width: 50, height: 50), type: .circleStrokeSpin, color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1), backgroundColor: .clear)
    self.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
  }
  
  func sumwhereStop(){
    self.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
  }
}
