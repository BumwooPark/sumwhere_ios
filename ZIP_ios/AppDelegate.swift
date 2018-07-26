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
import RxOptional
import Moya
import SwiftyJSON
import Firebase
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit
import SwiftyImage
import SwiftyUserDefaults


let tokenObserver = PublishSubject<String>()
let log = SwiftyBeaver.self
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let disposeBag = DisposeBag()
  let gcmMessageIDKey = "gcm.message_id"
  var proxyController: ProxyController!
  
  static var instance: AppDelegate? {
    return UIApplication.shared.delegate as? AppDelegate
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
//    window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    window?.rootViewController = UIViewController()
    proxyController = ProxyController(window: window)
    proxyController.makeRootViewController()
    
    tokenObserver
      .do(onNext: { (token) in
        if token.length > 0 {
        Defaults[.token] = token
        AuthManager.provider = MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: Defaults[.token]),NetworkLoggerPlugin(verbose: true)]).rx
        }else{
          Defaults.remove("token")
        }
        Defaults.synchronize()
      })
      .delay(1, scheduler: MainScheduler.instance)
      .subscribe(onNext: {[weak self] (token) in
        self?.proxyController.makeRootViewController()
    }).disposed(by: disposeBag)
    
    faceBookSetting(application: application, didFinishLaunchingWithOptions: launchOptions)
    FirebaseApp.configure()
    loggingSetting()
    appearanceSetting()
    JDSetting()
    
    Messaging.messaging().delegate = self
    
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: {_, _ in })
    application.registerForRemoteNotifications()
    
    GMSServices.provideAPIKey("AIzaSyBPAZRNVRsxpYAHm_7_sReQOoQWVc8umf8")
    GMSPlacesClient.provideAPIKey("AIzaSyBPAZRNVRsxpYAHm_7_sReQOoQWVc8umf8")
    return true
  }
  
  private func faceBookSetting(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?){
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func loggingSetting(){
    // add log destinations. at least one is needed!
    let console = ConsoleDestination()  // log to Xcode Console
    console.format = "$DHH:mm:ss$d $C$L$c $N.$F:$l - $M"
    // or use this for JSON output: console.format = "$J"
    log.addDestination(console)
    
  }
  
  private func appearanceSetting(){
    
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().tintColor = nil
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    KOSession.handleDidEnterBackground()
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    KOSession.handleDidBecomeActive()
  }
  
  func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    
    if KOSession.handleOpen(url) {
      return KOSession.handleOpen(url)
    }
    return false
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation){
      return true
    }
    
    if KOSession.isKakaoAccountLoginCallback(url) {
      return KOSession.handleOpen(url)
    }
    return false
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//      openURL:url
//      sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
    
    
    if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options){
      return true
    }
    
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
//    Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    var token = ""
    for i in 0..<deviceToken.count {
    token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
    }
    
    if let refreshedToken = InstanceID.instanceID().token() {
      log.verbose("InstanceID token: \(refreshedToken)")
    }
  
    log.info("디바이스토큰:\(token)")
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      log.info("Message ID: \(messageID)")
    }
    
    // Print full message.
    log.info(userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    completionHandler(UIBackgroundFetchResult.newData)
  }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
//     Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      log.info("Message ID: \(messageID)")
    }
    
    // Print full message.
    log.info(userInfo)
    
    // Change this to your preferred presentation option
    completionHandler([])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      log.info("Message ID: \(messageID)")
    }
    
    // Print full message.
    log.info(userInfo)
    
    completionHandler()
  }
}

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    log.info("Firebase registration token: \(fcmToken)")
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }

  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    log.info("Received data message: \(remoteMessage.appData)")
  }
}


