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
  
  private func serverHaveProfile(){
      provider.request(.isProfile)
        .filter(statusCode: 200)
        .subscribe(onSuccess: { [weak self](response) in
          guard let retainSelf = self else {return}
          retainSelf.window?.rootViewController = MainViewController3()
        }) { [weak self](error) in
          let moyaError = error as? MoyaError
          if moyaError?.response?.statusCode == 406,
            let retainSelf = self {
          retainSelf.window?.rootViewController = SetProfileViewController()
          }else{
            log.error(error)
          }
    }.disposed(by: disposeBag)
  }
  
  func makeRootViewController(){
    if Defaults[.token].length != 0 {
      window?.rootViewController = SlideMenuController(mainViewController: MainTabBarController(), rightMenuViewController: SideMenuViewController())
    }else {
      window?.rootViewController = LoginViewController()
    }
  }
}
