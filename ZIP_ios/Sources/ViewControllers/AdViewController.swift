//
//  AdViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import CHIPageControl
import RxSwift

final class AdViewController: UIViewController{
  var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  var pageView: PageViewController!
  
  let pageControl: CHIPageControlAleppo = {
    let control = CHIPageControlAleppo()
    control.numberOfPages = 3
    control.radius = 4
    control.currentPageTintColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    control.tintColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    control.padding = 6
    return control
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let one = UIViewController()
    one.view.backgroundColor = .red
    let two = UIViewController()
    two.view.backgroundColor = .blue
    let three = UIViewController()
    three.view.backgroundColor = .yellow
    
    pageView = PageViewController(pages: [one,two,three], spin: true)
    addChildViewController(pageView)
    view.addSubview(pageView.view)
    pageView.didMove(toParentViewController: self)
    view.addSubview(pageControl)
    view.setNeedsUpdateConstraints()
    
    pageView.currentIndexSubject
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return { idx in
          weakSelf.pageControl.set(progress: idx, animated: true)
        }
    }.disposed(by: disposeBag)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      pageView.view.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      pageControl.snp.makeConstraints { (make) in
        make.top.right.equalToSuperview().inset(10)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
  override func willMove(toParentViewController parent: UIViewController?) {
    super.willMove(toParentViewController: parent)
  }
  
  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
  }
}
