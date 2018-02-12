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

class ProxyController{
  let disposeBag = DisposeBag()
  let mainVC = MainTabBarController()
  let welcomeVC = WelcomeViewController()
  let kakao = NotificationCenter.default.rx
    .notification(NSNotification.Name.KOSessionDidChange)
    .map{ _ in KOSession.shared().isOpen()}
    .observeOn(MainScheduler.instance)
    .share()
  
  let defaultLogin = UserDefaults.standard.rx
    .observe(Bool.self, UserDefaultType.isLogin.rawValue)
    .filterNil()
    .observeOn(MainScheduler.instance)
    .share()

  let window: UIWindow?
 
  init(window: UIWindow?) {
    self.window = window

    Observable<Bool>.merge([kakao,defaultLogin])
      .map { _ in return ()}
      .debug()
      .bind(onNext: makeRootViewController)
      .disposed(by: disposeBag)
  }
  
  func makeRootViewController(){
    let isLogin = UserDefaults.standard.bool(forKey: UserDefaultType.isLogin.rawValue)
    
    if isLogin || KOSession.shared().isOpen(){
      window?.rootViewController = MainTabBarController()
      return
    }
    
    window?.rootViewController = WelcomeViewController()
  }
}
