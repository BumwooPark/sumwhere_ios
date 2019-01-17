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
  var completed = false
  var pageView: PageViewController!
  
  let pageControl: CHIPageControlAleppo = {
    let control = CHIPageControlAleppo()
    control.radius = 4
    control.currentPageTintColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    control.tintColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    control.padding = 6
    return control
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let result = AuthManager.instance.provider.request(.banner)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[BannerModel]>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
    
    result.elements()
      .map{$0.map({ BannerViewController(banner: $0)})}
      .bind(onNext: pageViewSetting)
      .disposed(by: disposeBag)
    
    result.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
        }
    }.disposed(by: disposeBag)
  }
  
  func pageViewSetting(banners: [UIViewController]){
    
    pageView = PageViewController(pages: banners, spin: true)
    addChild(pageView)
    view.addSubview(pageView.view)
    pageView.didMove(toParent: self)
    view.addSubview(pageControl)
    view.setNeedsUpdateConstraints()
    
    pageControl.numberOfPages = banners.count
    pageView.currentIndexSubject
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return { idx in
          weakSelf.pageControl.set(progress: idx, animated: true)
        }
      }.disposed(by: disposeBag)
    
    pageView.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    pageControl.snp.makeConstraints { (make) in
      make.top.right.equalToSuperview().inset(10)
    }
    completed = true
  }
  
  
//  override func updateViewConstraints() {
//    if !didUpdateConstraint{
//      pageView.view.snp.makeConstraints { (make) in
//        make.edges.equalToSuperview()
//      }
//
//      pageControl.snp.makeConstraints { (make) in
//        make.top.right.equalToSuperview().inset(10)
//      }
//      didUpdateConstraint = true
//    }
//    super.updateViewConstraints()
//  }
  
  override func willMove(toParent parent: UIViewController?) {
    super.willMove(toParent: parent)
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
  }
}
