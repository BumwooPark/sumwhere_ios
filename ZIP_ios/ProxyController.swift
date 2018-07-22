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
import SlideMenuControllerSwift

class ProxyController{
  let disposeBag = DisposeBag()
  let mainVC = MainTabBarController()
  let welcomeVC = LoginViewController()
  let provider = AuthManager.provider
  let defaultLogin = UserDefaults.standard.rx
    .observe(Bool.self, UserDefaultType.isLogin.rawValue)
    .filterNil()
    .observeOn(MainScheduler.instance)
    .share()

  let window: UIWindow?
 
  init(window: UIWindow?) {
    self.window = window

    defaultLogin
      .filter{$0}
      .map({ _ -> () in return ()})
      .bind(onNext: makeRootViewController)
      .disposed(by: disposeBag)
  }
  
  func makeRootViewController(){
    if Defaults[.token].length != 0{
      window?.rootViewController = SlideMenuController(mainViewController: MainTabBarController(), leftMenuViewController: SideMenuViewController())
    }else {
      window?.rootViewController = LoginViewController()
    }
  }
}
