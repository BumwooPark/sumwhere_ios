//
//  LoginUtil.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import FBSDKLoginKit
import RxSwift
import RxCocoa
import SwiftyUserDefaults

class LoginKit{
  static func facebookLogin(manager: FBSDKLoginManager, Permissions:[String], from: UIViewController, result: @escaping (Bool) -> ()){
    
    manager.logIn(withReadPermissions: Permissions, from: from) { (fbresult, error) in
      guard let isCancelled = fbresult?.isCancelled else {return}
      if isCancelled{
        result(false)
      }
      
      if error != nil {
        result(false)
      }
      
      if error == nil && !isCancelled{
        result(true)
      }
    }
  }
  
  static func kakaoLogin(result: @escaping (Bool) -> ()){
    let session: KOSession = KOSession.shared()
    
    if session.isOpen() {session.close()}
    session.open(completionHandler: {(error) -> Void in
      KOSessionTask.userMeTask(completion: { (error, user) in
        if error != nil {
          result(false)
        }else {
          result(true)
        }
      })
      }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue),
                     NSNumber(value: KOAuthType.account.rawValue)])
  }
}

