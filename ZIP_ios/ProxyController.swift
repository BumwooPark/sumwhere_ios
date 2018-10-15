//
//  ProxyViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 8..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyUserDefaults
import Moya

class ProxyController{
  let disposeBag = DisposeBag()
  let window: UIWindow?

  init(window: UIWindow?) {
    self.window = window
  }
  
  func profileCheck(){
    let isProfile = AuthManager.instance
      .provider.request(.isProfile)
      .map(ResultModel<Bool>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
    
    let tokenLogin = AuthManager.instance
      .provider.request(.tokenLogin)
      .map(ResultModel<Bool>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
    
    Observable<UIViewController>
      .combineLatest(isProfile, tokenLogin) { (profile, login)in
      let loginVC = UINavigationController(rootViewController: WelcomeViewController())
//      loginVC.navigationBar.prefersLargeTitles = true
      loginVC.navigationBar.largeTitleTextAttributes = [.font: UIFont.NotoSansKRMedium(size: 40),.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
      loginVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
      
      if !login {
        return loginVC
      }else {
        if !profile{
          loginVC.addChild(NewSetProfileViewController())
          return loginVC
        }else{
          return MainTabBarController()
        }
      }
      }.subscribe(weak: self) { (weakSelf) -> (Event<UIViewController>) -> Void in
        return {event in
          switch event{
          case .next(let element):
            AppDelegate.instance?.window?.rootViewController = element
          case .error(let error):
            guard let err = error as? MoyaError else {return}
            err.GalMalErrorHandler()
          case .completed:
            log.info("complete")
          }
        }
    }.disposed(by: disposeBag)
  }
  
  func makeRootViewController(){
    
    if Defaults[.token].count != 0{
      profileCheck()
    }else {
      let naviVC = UINavigationController(rootViewController: WelcomeViewController())
      naviVC.hero.isEnabled = true
      naviVC.hero.navigationAnimationType = .fade
      naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "fill1.png")
      naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "fill1.png")
      naviVC.navigationBar.backItem?.title = String()
      window?.rootViewController = naviVC
    }
  }
}
