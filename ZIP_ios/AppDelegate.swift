//
//  AppDelegate.swift
//  ZIP
//
//  Created by park bumwoo on 2017. 10. 3..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaps
import GooglePlaces
import SwiftyBeaver
import RxSwift
import RxCocoa


let log = SwiftyBeaver.self
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let disposeBag = DisposeBag()
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    NotificationCenter.default.rx
      .notification(NSNotification.Name.KOSessionDidChange)
      .subscribe { [weak self](event) in
        log.verbose(event)
        self?.makeRootController()
      }.disposed(by: disposeBag)
    
    loggingSetting()
    GMSServices.provideAPIKey("AIzaSyBPAZRNVRsxpYAHm_7_sReQOoQWVc8umf8")
    GMSPlacesClient.provideAPIKey("AIzaSyBPAZRNVRsxpYAHm_7_sReQOoQWVc8umf8")
    kakaoAppConnect()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    makeRootController()
    
    return true
  }
  
  private func makeRootController(){
    let isopen = KOSession.shared().isOpen()
    if isopen{
      KOSessionTask.meTask(completionHandler: {[weak self] (result, error) in
        if (result != nil){
          if let user = result as? KOUser{
            let email = user.email ?? ""
            let userId = "\(user.id)"
            let nickname = user.property(forKey: KOUserNicknamePropertyKey) as? String
            log.info("email:\(email), userId:\(userId), nickname: \(nickname)")
          }
        }
      })
    }
    
    window?.rootViewController = isopen ? MainTabBarController() : WelcomeViewController()
  }
  
  private func kakaoAppConnect(){
    
    KOSessionTask.signupTask(withProperties: nil) { (status, error) in
      if status {
        log.info("success")
      }else{
        log.error(error?.localizedDescription)
      }
    }
  }
  
  private func loggingSetting(){
    // add log destinations. at least one is needed!
    let console = ConsoleDestination()  // log to Xcode Console
    let file = FileDestination()  // log to default swiftybeaver.log file
    let cloud = SBPlatformDestination(appID: "", appSecret: "", encryptionKey: "") // to cloud
    
    // use custom format and set console output to short time, log level & message
    console.format = "$DHH:mm:ss$d $C$L$c $N.$F:$l - $M"
    // or use this for JSON output: console.format = "$J"
    
    // add the destinations to SwiftyBeaver
    log.addDestination(console)
    log.addDestination(cloud)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    KOSession.handleDidEnterBackground()
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    KOSession.handleDidBecomeActive()
  }
  func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    if KOSession.handleOpen(url) {
      return true
    }
    return false
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if KOSession.handleOpen(url) {
      return true
    }
    return false
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    if KOSession.handleOpen(url) {
      return true
    }
    return false
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    KOSession.handleDidBecomeActive()
  }
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    log.error("didFailToRegisterForRemoteNotificationsWithError=\(error.localizedDescription)")
  }
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //    self.deviceToken = deviceToken
    //    log.error("didRegisterForRemoteNotificationsWithDeviceToken=\(deviceToken)")
  }
}

