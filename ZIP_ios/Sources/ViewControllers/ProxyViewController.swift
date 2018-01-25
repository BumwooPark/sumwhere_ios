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

class ProxyViewController{
  let disposeBag = DisposeBag()
  let mainVC = MainTabBarController()
  let welcomeVC = WelcomeViewController()
  
 
  //  // retrieving a value for a key
  //  if let data = UserDefaults.standard.data(forKey:  #YOUR KEY#),
  //  let obj = NSKeyedUnarchiver.unarchiveObject(with: data) as? #YOUR OBJECT# {
  //  } else {
  //  print("There is an issue")
  //  }
  
  init() {
    
    UserDefaults.standard.rx.observe(TokenModel.self, "token")
      .observeOn(MainScheduler.instance)
      .filterNil()
      .subscribe { (event) in
        log.info(event.element?.access_token)
    }.disposed(by: disposeBag)
    
    
  }
}
