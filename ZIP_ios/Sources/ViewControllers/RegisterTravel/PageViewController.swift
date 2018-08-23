//
//  PageViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 28..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

class PageViewController: UIPageViewController{
  
  var pages: [UIViewController]
  var currentIndexSubject = PublishSubject<Int>()
  let spin: Bool
  
  init(pages: [UIViewController], spin: Bool) {
    self.pages = pages
    self.spin = spin
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.dataSource = self
    self.delegate = self
    
    if let firstVC = pages.first{
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
  }
  
  fileprivate func scrollToViewController(_ viewController: UIViewController,direction: UIPageViewControllerNavigationDirection = .forward) {
    setViewControllers([viewController],direction: direction,animated: true,completion: { (finished) -> Void in
      DispatchQueue.main.async {
        self.notifyDelegateOfNewIndex()
      }
    })
  }
  
  fileprivate func notifyDelegateOfNewIndex() {
    if let firstViewController = viewControllers?.first,
      let index = pages.index(of: firstViewController) {
      currentIndexSubject.onNext(Int(index))
    }
  }
  
  func scrollToViewController(index newIndex: Int) {
    if let firstViewController = viewControllers?.first,let currentIndex = pages.index(of: firstViewController) {
      let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
      let nextViewController = pages[newIndex]
        scrollToViewController(nextViewController, direction: direction)
    }
  }
}

extension PageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate{
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pages.index(of: viewController) else {return nil}
    currentIndexSubject.onNext(Int(viewControllerIndex))
    let previousIndex = viewControllerIndex - 1
    if !spin{
      guard previousIndex >= 0 else {return nil}
      guard pages.count > previousIndex else {return nil}
      return pages[previousIndex]
    }else{
      guard previousIndex >= 0 else {return pages.last}
      return pages[previousIndex]
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pages.index(of: viewController) else {return nil}
    currentIndexSubject.onNext(Int(viewControllerIndex))
    let nextIndex = viewControllerIndex + 1
    if !spin{
      guard pages.count > nextIndex else {return nil}
      return pages[nextIndex]
    }else{
      guard pages.count > nextIndex else {return pages.first}
      return pages[nextIndex]
    }
  }
}
