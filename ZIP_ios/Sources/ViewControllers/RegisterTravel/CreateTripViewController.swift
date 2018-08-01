//
//  CreateTripViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import DropDown
import RxCocoa
import RxDataSources
import RxSwift
import RxGesture
import Hero
import SnapKit

class CreateTripViewController: UIViewController{
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  let ticketView = TicketView.loadXib(nibName: "TicketView") as! TicketView
  
  lazy var pageView = PageViewController(pages: [SearchDestinationViewController(viewController: self),
                                                 InsertPlanViewController(viewController: self),
                                            InsertPeopleViewController(viewController: self),
                                            RegisterViewController(viewController: self)])
  
  var constraint: Constraint?
  
  let control: UIPageControl = {
    let control = UIPageControl()
    control.numberOfPages = 4
    control.pageIndicatorTintColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 0.3925506162)
    control.currentPageIndicatorTintColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    return control
  }()
  
  lazy var viewModel = TripRegisterViewModel(view: ticketView)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    self.addChildViewController(pageView)
    view.addSubview(pageView.view)
    view.addSubview(ticketView)
    view.addSubview(control)
  
    
    self.navigationItem.hidesBackButton = true
    pageView.currentIndex = {[weak self] index in
      self?.control.currentPage = index
      
      
      if index == 3{
        self?.control.isHidden = true
        self?.constraint?.update(inset: 100)
      }else{
        self?.control.isHidden = false
        self?.constraint?.update(inset: 0)
      }
      
      UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
        self?.view.setNeedsLayout()
        self?.view.layoutIfNeeded()
      }, completion: nil)
    }
    

    view.setNeedsUpdateConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      ticketView.snp.makeConstraints { (make) in
        make.left.equalTo(self.view.snp.leftMargin)
        make.right.equalTo(self.view.snp.rightMargin)
        self.constraint = make.top.equalTo(self.view.snp.topMargin).constraint
        make.height.equalTo(175)
      }
      
      control.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.snp.topMargin).inset(185)
        make.centerX.equalToSuperview()
        make.height.equalTo(20)
      }
      
      pageView.view.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview()
        make.bottom.equalToSuperview()
        make.top.equalTo(control.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }

}

