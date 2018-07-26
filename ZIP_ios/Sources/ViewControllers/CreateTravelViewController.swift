//
//  CreateTravelViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class CreateTravelViewController: UIViewController{
  
  var didUpdateConstraint = false
  
  let ticketView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    return view
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(ticketView)
    
    view.setNeedsUpdateConstraints()
  }
  
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      ticketView.snp.makeConstraints { (make) in
        make.left.equalTo(self.view.snp.leftMargin)
        make.right.equalTo(self.view.snp.rightMargin)
        make.top.equalTo(self.view.snp.topMargin)
        make.height.equalTo(150)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
}
