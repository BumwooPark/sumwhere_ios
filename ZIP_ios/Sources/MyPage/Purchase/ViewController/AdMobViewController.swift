//
//  AdMobViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import Firebase

class AdMobViewController: UIViewController, RewardAction{
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func Action() {
    if GADRewardBasedVideoAd.sharedInstance().isReady {
      GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: AppDelegate.instance?.window?.rootViewController ?? UIViewController())
    }
  }
}

extension AdMobViewController: GADRewardBasedVideoAdDelegate{
  func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                          didRewardUserWith reward: GADAdReward) {
    log.info("Reward received with currency: \(reward.type), amount \(reward.amount).")
  }
  
  func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
    log.info("Reward based video ad is received.")
  }
  
  func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    log.info("Opened reward based video ad.")
  }
  
  func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    log.info("Reward based video ad started playing.")
  }
  
  func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    log.info("Reward based video ad has completed.")
  }
  
  func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    log.info("Reward based video ad is closed.")
  }
  
  func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    log.info("Reward based video ad will leave application.")
  }
  
  func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                          didFailToLoadWithError error: Error) {
    log.info("Reward based video ad failed to load.")
  }
}
