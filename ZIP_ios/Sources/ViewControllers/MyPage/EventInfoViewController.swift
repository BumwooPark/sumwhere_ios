//
//  EventInfoViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 12/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import HMSegmentedControl
import RxSwift
import RxCocoa


class EventInfoViewController: UIViewController{
  private let disposeBag = DisposeBag()
  private let container = PageViewController(pages: [InfoPageViewController(),EventPageViewController()], spin: false)
  
  private var didUpdateConstraint = false
  private let segmentControl: HMSegmentedControl = {
    let control = HMSegmentedControl(sectionTitles: ["공지사항","이벤트"])!
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
    addChild(container)
    view.addSubview(container.view)
    container.didMove(toParent: self)
    
    
    container.currentIndexSubject
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {idx in
          weakSelf.segmentControl.setSelectedSegmentIndex(UInt(idx), animated: true)
        }
      }.disposed(by: disposeBag)
    
    segmentControl.rx.controlEvent(UIControlEvents.valueChanged)
      .map{[unowned self] _ in return self.segmentControl.selectedSegmentIndex}
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {idx in
          log.info(idx)
          weakSelf.container.scrollToViewController(index: idx)
        }
    }.disposed(by: disposeBag)
    
    
    view.setNeedsUpdateConstraints()
  }

  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      segmentControl.snp.makeConstraints { (make) in
        make.left.right.top.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(50)
      }
      
      container.view.snp.makeConstraints { (make) in
        make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        make.top.equalTo(segmentControl.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

