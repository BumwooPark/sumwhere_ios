//
//  CurrentSendViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import HMSegmentedControl
import RxSwift

class CurrentMatchViewController: UIViewController{
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  let vc1: MatchHistoryViewController = {
    let vc = MatchHistoryViewController(type: .Send)
    return vc
  }()
  
  let vc2: MatchHistoryViewController = {
    let vc = MatchHistoryViewController(type: .Receive)
    return vc
  }()
  
  lazy var pageViewController = PageViewController(pages: [vc1,vc2], spin: false)
  
  let control: HMSegmentedControl = {
    let control = HMSegmentedControl()
    control.sectionTitles = ["보낸동행","받은동행"]
    control.selectedTitleTextAttributes = [NSAttributedStringKey.font: UIFont.NotoSansKRBold(size: 20)]
    control.selectionIndicatorLocation = .down
    return control
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(control)
    addChildViewController(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.didMove(toParentViewController: self)
    
    pageViewController
      .currentIndexSubject
      .subscribeNext(weak: self) { (retainSelf) -> (Int) -> Void in
        return { idx in
          retainSelf.control.selectedSegmentIndex = idx
        }
    }.disposed(by: disposeBag)
    
    control.rx
      .controlEvent(.valueChanged)
      .subscribeNext(weak: self) { (retainSelf) -> (()) -> Void in
        return {_ in
          retainSelf.pageViewController.scrollToViewController(index: retainSelf.control.selectedSegmentIndex)
        }
    }.disposed(by: disposeBag)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{

      control.snp.makeConstraints { (make) in
        make.left.top.right.equalTo(view.safeAreaLayoutGuide)
        make.height.equalTo(50)
      }
      
      pageViewController.view.snp.makeConstraints { (make) in
        make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        make.top.equalTo(control.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
