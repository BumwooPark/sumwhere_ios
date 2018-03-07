//
//  SetPlanViewController2.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 24..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlanPageController: UIPageViewController {
  
  var pageViewControllers: [UIViewController] = []
  let pageScrolled = Variable<Int>(0)
  
  override func viewDidLoad(){
    dataSource = self
    delegate = self
    view.backgroundColor = .white
    if let initialViewController = pageViewControllers.first {
      scrollToViewController(initialViewController)
    }
  }
  
  fileprivate func scrollToViewController(_ viewController: UIViewController,direction: UIPageViewControllerNavigationDirection = .forward) {
    setViewControllers([viewController],direction: direction,animated: true,completion: { (finished) -> Void in
      // Setting the view controller programmatically does not fire
      // any delegate methods, so we have to manually notify the
      // 'tutorialDelegate' of the new index.
      self.notifyDelegateOfNewIndex()
    })
  }
  
  fileprivate func notifyDelegateOfNewIndex() {
    if let firstViewController = viewControllers?.first,
      let index = pageViewControllers.index(of: firstViewController) {
      pageScrolled.value = Int(index)
    }
  }
  
  func scrollToViewController(index newIndex: Int) {
    if let firstViewController = viewControllers?.first,let currentIndex = pageViewControllers.index(of: firstViewController) {
      let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
      let nextViewController = pageViewControllers[newIndex]
      scrollToViewController(nextViewController, direction: direction)
    }
  }
}


extension PlanPageController: UIPageViewControllerDelegate{
  func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    notifyDelegateOfNewIndex()
  }
}

extension PlanPageController: UIPageViewControllerDataSource{
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pageViewControllers.index(of: viewController) else {
      return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    let pageViewControllersCount = pageViewControllers.count
    
    guard pageViewControllersCount > nextIndex else {
      return nil
    }
    
    return pageViewControllers[nextIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pageViewControllers.index(of: viewController) else {
      return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    guard previousIndex >= 0 else {
      return nil
    }
    
    guard pageViewControllers.count > previousIndex else {
      return nil
    }
    
    return pageViewControllers[previousIndex]
  }
  
}
