//
//  CurrentSendViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import HMSegmentedControl
import RxSwift
import Swinject

final class MatchHistoryViewController: UIViewController{
  
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  
  let vc1: HistoryViewController = {
    let vc = HistoryViewController(viewModel: RequestHistoryViewModel())
    return vc
  }()

  let vc2: HistoryViewController = {
    let vc = HistoryViewController(viewModel: ReceiveHistoryViewModel())
    return vc
  }()
  
  lazy var pageViewController = PageViewController(pages: [vc1,vc2], spin: false)
  private let segmentControl: HMSegmentedControl = {
    let control = HMSegmentedControl(sectionTitles: ["보낸 요청","받은 요청"])!
    control.selectionStyle = .fullWidthStripe
    control.selectionIndicatorLocation = .down
    control.selectionIndicatorColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    control.selectionIndicatorHeight = 2
    control.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)]
    control.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1),
                                   NSAttributedString.Key.font: UIFont.AppleSDGothicNeoMedium(size: 17)]
    return control
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(segmentControl)
    addChild(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.view.backgroundColor = .clear
    pageViewController.didMove(toParent: self)
    pageViewController.isPagingEnabled = false
    
    pageViewController.currentIndexSubject
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {idx in
          weakSelf.segmentControl.setSelectedSegmentIndex(UInt(idx), animated: true)
        }
      }.disposed(by: disposeBag)
    
    segmentControl.rx.controlEvent(UIControl.Event.valueChanged)
      .map{[weak self] _ in return self?.segmentControl.selectedSegmentIndex}
      .unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {idx in
          weakSelf.pageViewController.scrollToViewController(index: idx)
        }
      }.disposed(by: disposeBag)

    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      segmentControl.snp.makeConstraints { (make) in
        make.top.equalTo(view.safeAreaLayoutGuide)
        make.left.right.equalToSuperview()
        make.height.equalTo(40)
      }
      
      pageViewController.view.snp.makeConstraints { (make) in
        make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        make.top.equalTo(segmentControl.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
