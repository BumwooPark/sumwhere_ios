//
//  CurrentSendViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import HMSegmentedControl
import BetterSegmentedControl
import RxSwift

class MatchRequestViewController: UIViewController{
  
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
  
  private let segment: BetterSegmentedControl = {
    let segment = BetterSegmentedControl(
      frame: .zero,
      segments: LabelSegment.segments(withTitles: ["보낸 요청","받은 요청"],
                                      normalBackgroundColor: .clear,
                                      normalFont: .AppleSDGothicNeoSemiBold(size: 14),
                                      normalTextColor: #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1),
                                      selectedBackgroundColor: .white,
                                      selectedFont: .AppleSDGothicNeoSemiBold(size: 14),
                                      selectedTextColor: .black),
      index: 0,
      options: [.backgroundColor(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)),.cornerRadius(10)])
    return segment
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(segment)
    addChild(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.view.backgroundColor = .clear
    pageViewController.didMove(toParent: self)
    pageViewController.isPagingEnabled = false
    
    segment.rx
      .controlEvent(.valueChanged)
      .map{[unowned self] in return Int(self.segment.index)}
      .bind(onNext: pageViewController.scrollToViewController)
      .disposed(by: disposeBag)

    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      segment.snp.makeConstraints { (make) in
        make.top.equalTo(view.safeAreaLayoutGuide)
        make.left.right.equalToSuperview().inset(32)
        make.height.equalTo(40)
      }
      
      pageViewController.view.snp.makeConstraints { (make) in
        make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        make.top.equalTo(segment.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
