//
//  ProxyViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 19..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional


struct ProxyViewController{
  static func proxyViewController(){
    let token = UserDefaults.standard.object(forKey: "access_token") as? String
    AuthManager.sharedManager.authProvider
      .rx
      .request(.auth)
      .asObservable()
      .jsonMap()
    
  }
}

