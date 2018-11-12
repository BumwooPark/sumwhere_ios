//
//  EventInfoViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 12/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import HMSegmentedControl

class EventInfoViewController: UIViewController{
  
  let container = PageViewController()
  
  var didUpdateConstraint = false
  let segmentControl: HMSegmentedControl = {
    let control = HMSegmentedControl(sectionTitles: ["공지사항","이벤트"])!
    return control
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(segmentControl)
    view.setNeedsUpdateConstraints()
  }
  
  
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      segmentControl.snp.makeConstraints { (make) in
        make.left.right.top.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(50)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
