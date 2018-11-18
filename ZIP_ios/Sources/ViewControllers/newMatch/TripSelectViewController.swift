//
//  TripSelectViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 16/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

class TripSelectViewController: UIViewController {
  
  lazy var pageView: PageViewController = {
    let pageView = PageViewController(pages: [OneTimeMatchViewController(),PlanTripViewController()], spin: false)
    return pageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(pageView)
    view.addSubview(pageView.view)
    pageView.didMove(toParent: self)
  }
}
