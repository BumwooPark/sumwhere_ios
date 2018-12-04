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
import RxSwiftExt
import Moya
import SwiftyJSON
import Firebase
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit
import SwiftyImage
import SwiftyUserDefaults
import Fabric
import Crashlytics
import StoreKit


let tokenObserver = PublishSubject<String>()
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let disposeBag = DisposeBag()
  let gcmMessageIDKey = "gcm.message_id"
  
  static var instance: AppDelegate? {
    return UIApplication.shared.delegate as? AppDelegate
  }
 
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Fabric.with([Crashlytics.self])
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()

//    window?.rootViewController = ProxyViewController()
    window?.rootViewController = OneTimeMatchSelectViewController()
    tokenObserver
      .do(onNext: { (token) in
        if token.count > 0 {
        Defaults[.token] = token
          Defaults.synchronize()
          AuthManager.instance.updateProvider()
        }else{
          Defaults.remove("token")
          Defaults.synchronize()
        }
      })
      .delay(1, scheduler: MainScheduler.instance)
      .subscribeNext(weak: self, { (weakSelf) -> (String) -> Void in
        return {token in
          weakSelf.window?.rootViewController = ProxyViewController()
        }
      }).disposed(by: disposeBag)

    faceBookSetting(application: application, didFinishLaunchingWithOptions: launchOptions)
    FirebaseApp.configure()
    loggingSetting()
    appearanceSetting()
    JDSetting()
    
    // in App 결제
//    SKPaymentQueue.default().add(self)
    
    KOSession.shared()?.isAutomaticPeriodicRefresh = true
    
    Messaging.messaging().delegate = self
    
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: {_, _ in })
    application.registerForRemoteNotifications()
    
    GADMobileAds.configure(withApplicationID: "ca-app-pub-4059652237278086~5901401126")
    GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
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
    UITabBar.appearance().layer.borderWidth = 0
    UITabBar.appearance().clipsToBounds = true
    UITabBar.appearance().backgroundColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().tintColor = .black
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
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
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
    log.info(application.applicationState)
    
    log.info(userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    if let messageID = userInfo[gcmMessageIDKey] {
      log.info("Message ID: \(messageID)")
    }
    
    // Print full message.
    log.info(userInfo)
    
    completionHandler(UIBackgroundFetchResult.newData)
  }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  // 앱이 실행중 노티처리
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    log.info(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      log.info("Message ID: \(messageID)")
    }
  
    if let apns = userInfo[AnyHashable("aps")] as? NSDictionary{
      if let bedge = apns["badge"] as? Int {
        log.info("성공")
        UIApplication.shared.applicationIconBadgeNumber = bedge
      }else{
        log.info(apns["badge"])
      }
    }
    
    // Change this to your preferred presentation option
    completionHandler([.alert,.badge,.sound])
  }
  
  // 앱이 백그라운드나 종료시 처리
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


//extension AppDelegate: SKPaymentTransactionObserver{
//  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//    for transaction in transactions{
//      switch transaction.transactionState{
//      case .purchased:
//        complete(transaction: transaction)
//      case .failed:
//        fail(transaction: transaction)
//      case .restored:
//        restore(transaction: transaction)
//      case .deferred:
//        break
//      case .purchasing:
//        break
//      }
//    }
//  }
//
//  public func complete(transaction: SKPaymentTransaction){
//
//    SKPaymentQueue.default().finishTransaction(transaction)
//
//    let receiptURL = Bundle.main.appStoreReceiptURL
//    do {
//      let receipt = try Data(contentsOf: receiptURL!)
//
//      AuthManager.instance
//        .provider
//        .request(.IAPSuccess(receipt: receipt.base64EncodedString()))
//        .subscribe(onSuccess: { (response) in
//          log.info(response)
//        }) { (error) in
//          log.error(error)
//      }.disposed(by: disposeBag)
//
//    }catch let error {
//      log.error(error)
//    }
//  }
//
//  private func restore(transaction: SKPaymentTransaction) {
//    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
//    log.info("restore... \(productIdentifier)")
//    SKPaymentQueue.default().finishTransaction(transaction)
//  }
//
//  private func fail(transaction: SKPaymentTransaction) {
//    log.info("fail...")
//    if let transactionError = transaction.error as NSError?,
//      let localizedDescription = transaction.error?.localizedDescription,
//      transactionError.code != SKError.paymentCancelled.rawValue {
//      log.info("Transaction Error: \(localizedDescription)")
//    }
//    SKPaymentQueue.default().finishTransaction(transaction)
//  }
//}
