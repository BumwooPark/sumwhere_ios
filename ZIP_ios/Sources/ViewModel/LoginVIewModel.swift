//
//  LoginVIewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import JDStatusBarNotification
import FBSDKLoginKit



class LoginViewModel{
  let disposeBag = DisposeBag()
  let viewController: UIViewController
  init(viewController: UIViewController) {
    self.viewController = viewController
  }
  
  
  func facebookLogin(manager: FBSDKLoginManager){
    
    LoginKit.facebookLogin(manager: manager, Permissions: ["public_profile","email"], from: self.viewController) {(result) in
      if result{
        AuthManager.provider
          .request(.facebook(access_token: FBSDKAccessToken.current().tokenString))
          .map(ResultModel<TokenModel>.self)
          .subscribe(onSuccess: { (result) in
            if result.success{
              tokenObserver.onNext(result.result?.token ?? String())
            }else {
              JDStatusBarNotification.show(withStatus: result.error?.details ?? "로그인 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
            }
          }, onError: { (error) in
            JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
          })
      }
    }
  }
  
  func kakaoLogin(){
    LoginKit.kakaoLogin {[weak self] (result) in
      guard let `self` = self else {return}
      if result{
        AuthManager.provider
          .request(.kakao(access_token: KOSession.shared().token.accessToken))
          .map(ResultModel<TokenModel>.self)
          .subscribe(onSuccess: {(result) in
            if result.success{
              tokenObserver.onNext(result.result?.token ?? "")
            }else {
              JDStatusBarNotification.show(withStatus: result.error?.details ?? "로그인 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
            }
          }, onError: { (error) in
            JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
          }).disposed(by: self.disposeBag)
      }else{
        
        JDStatusBarNotification.show(withStatus: "로그인 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
      }
    }
  }
}
