//
//  PlanTripViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 17/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import MXParallaxHeader

class PlanTripViewController: UIViewController {
  let scrollView: MXScrollView = {
    let scrollView = MXScrollView()
    scrollView.parallaxHeader.height = 400
    scrollView.parallaxHeader.mode = .fill
    return scrollView
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
}

