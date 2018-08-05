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
  
  
  let isProfile = AuthManager.provider.request(.isProfile)
    .map(ResultModel<Bool>.self)
    .map{$0.result}
    .asObservable()
    .filterNil()
    .share()
  
  let tokenLogin = AuthManager.provider.request(.tokenLogin)
    .map(ResultModel<Bool>.self)
    .map{$0.result}
    .asObservable()
    .filterNil()
    .share()
 
  init(window: UIWindow?) {
    self.window = window
  }
  
  func profileCheck(){
    Observable<UIViewController>.combineLatest(isProfile, tokenLogin) { (profile, login)in
      let loginVC = UINavigationController(rootViewController: LoginViewController())
      loginVC.navigationBar.prefersLargeTitles = true
      loginVC.navigationBar.largeTitleTextAttributes = [.font: UIFont.BMJUA(size: 40),.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
      loginVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
      
      if !login {
        return loginVC
      }else {
        if !profile{
          loginVC.addChildViewController(SetProfileViewController(config: false))
          loginVC.navigationBar.topItem?.title = "프로필등록"
          return loginVC
        }else{
          return MainTabBarController()
        }
      }
      }.subscribe(onNext: { (vc) in
        AppDelegate.instance?.window?.rootViewController = vc
      }).disposed(by: disposeBag)
  }
  
  func makeRootViewController(){
    
    if Defaults[.token].length != 0{
      profileCheck()
    }else {
      window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
      AppDelegate.instance?.window?.makeKeyAndVisible()
    }
  }
}
