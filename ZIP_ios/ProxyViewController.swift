//
//  ProxyViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 31/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import NVActivityIndicatorView
import SwiftyUserDefaults

class ProxyViewController: UIViewController, NVActivityIndicatorViewable {
  private let disposeBag = DisposeBag()
  
  //프로필 존재하는지
  private let isProfile = AuthManager.instance
    .provider.request(.isProfile)
    .filterSuccessfulStatusCodes()
    .retry(3)
    .map(ResultModel<Bool>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  // 토큰이 유효한지
  private let tokenLogin = AuthManager.instance
    .provider.request(.tokenLogin)
    .filterSuccessfulStatusCodes()
    .retry(3)
    .map(ResultModel<Bool>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startAnimating(CGSize(width: 50, height: 50), type: .circleStrokeSpin, color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1),backgroundColor: .clear,fadeInAnimation: NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    viewSetting()
    kakaoTokenCheck()
    
    
    // 유저 정보 저장
    AuthManager.instance.provider
      .request(.userWithProfile)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<UserWithProfile>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .elements()
      .subscribe(onNext: { (model) in
        globalUserInfo = model
      }).disposed(by: disposeBag)
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
  
  private func loginCheck(){
    
    Observable.combineLatest(tokenLogin.elements(), isProfile.elements()) {($0, $1)}
      .subscribeNext(weak: self) { (weakSelf) -> ((Bool, Bool)) -> Void in
        return { result in
          let loginVC = UINavigationController(rootViewController: WelcomeViewController())
          loginVC.navigationBar.largeTitleTextAttributes = [.font: UIFont.NotoSansKRMedium(size: 40),.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
          loginVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
          if !result.0{
            AppDelegate.instance?.window?.rootViewController = loginVC
          }else {
            if !result.1{
              loginVC.addChild(NewSetProfileViewController())
              AppDelegate.instance?.window?.rootViewController = loginVC
            }else{
              AppDelegate.instance?.window?.rootViewController = MainTabBarController()
            }
          }
          weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        }
      }.disposed(by: disposeBag)
    
    tokenLogin.errors()
      .subscribeError(weak: self) { (weakSelf) -> (Error) -> Void in
        return { err in
          (err as? MoyaError)?.GalMalErrorHandler()
        }
    }.disposed(by: disposeBag)
    
    isProfile.errors()
      .subscribeError(weak: self) { (weakSelf) -> (Error) -> Void in
        return { err in
          (err as? MoyaError)?.GalMalErrorHandler()
        }
    }.disposed(by: disposeBag)
  }
  
  private func viewSetting() {
    if Defaults[.token].count != 0{
      loginCheck()
    }else {
      let naviVC = UINavigationController(rootViewController: WelcomeViewController())
      naviVC.hero.isEnabled = true
      naviVC.hero.navigationAnimationType = .fade
      naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "fill1.png")
      naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "fill1.png")
      naviVC.navigationBar.backItem?.title = String()
      
      let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {[weak self] in
         AppDelegate.instance?.window?.rootViewController = naviVC
        self?.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
      }
      animator.startAnimation()
    }
  }
}
