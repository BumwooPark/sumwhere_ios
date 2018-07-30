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
  
  func profileCheck(){
    
    AuthManager.provider.request(.isProfile)
      .map(ResultModel<Bool>.self)
      .asObservable()
      .subscribe(onNext: {[weak self] (model) in
        if model.success{
          if !model.result!{
            let rootview = self?.window?.rootViewController as? UINavigationController
            let profileView = SetProfileViewController()
            profileView.navigationItem.hidesBackButton = true 
            rootview?.pushViewController(profileView, animated: true)
          }else {
            let view = SlideMenuController(mainViewController: MainTabBarController(), leftMenuViewController: SideMenuViewController())
            view.title = "갈래말래"
            
            self?.window?.rootViewController = view
          }
        }
      }).disposed(by: disposeBag)
  }
  
  func makeRootViewController(){
    if Defaults[.token].length != 0{
      profileCheck()
    }else {
      window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
  }
}
