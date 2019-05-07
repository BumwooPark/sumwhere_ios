//
//  ProxyViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 31/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Moya
import NVActivityIndicatorView
import SwiftyUserDefaults
import FirebaseMessaging

class ProxyViewController: UIViewController, NVActivityIndicatorViewable {
  
  private let disposeBag = DisposeBag()
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startAnimating(CGSize(width: 50, height: 50), type: .circleStrokeSpin, color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1),backgroundColor: .clear,fadeInAnimation: NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    
    let tokanVerify = AuthManager.instance
      .provider
      .request(.verifyToken(token: Defaults[.token]))
      .filterSuccessfulStatusCodes()
      .asObservable()
      .materialize()
      .share()

    
    tokanVerify.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          tokenObserver.accept(String())
          weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
          let loginVC = UINavigationController(rootViewController: WelcomeViewController())
          AppDelegate.instance?.window?.rootViewController = loginVC
        }
    }.disposed(by: disposeBag)
    
    
    if Defaults[.token].count != 0{
      
      tokanVerify.elements()
        .subscribeNext(weak: self) { (weakSelf) -> (Response) -> Void in
          return {_ in
             AppDelegate.instance?.window?.rootViewController = MainTabBarController()
            weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
          }
      }.disposed(by: disposeBag)
    }else {
      let naviVC = UINavigationController(rootViewController: WelcomeViewController())
      naviVC.hero.isEnabled = true
      naviVC.hero.navigationAnimationType = .fade
      naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow.png")
      naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow.png")
      naviVC.navigationBar.backItem?.title = String()
      
      let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {[weak self] in
        AppDelegate.instance?.window?.rootViewController = naviVC
        self?.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
      }
      animator.startAnimation()
      
    }

    kakaoTokenCheck()
  }
  
  private func kakaoTokenCheck(){
    KOSessionTask.accessTokenInfoTask { (info, err) in
      if err != nil {
        log.error(err)
      }else{
        log.info(KOSession.shared()?.token.accessToken)
      }
    }
  }
}

