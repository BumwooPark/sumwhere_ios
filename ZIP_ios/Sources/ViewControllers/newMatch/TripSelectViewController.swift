//
//  TripSelectViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 16/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import IGListKit

class TripSelectViewController: UIViewController {
  
  lazy var pageView: PageViewController = {
    let pageView = PageViewController(pages: [OneTimeMatchViewController(),
                                              PlanTripViewController()], spin: false)
    pageView.view.backgroundColor = .white
    return pageView
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(pageView)
    view.addSubview(pageView.view)
    pageView.didMove(toParent: self)
  }
}
