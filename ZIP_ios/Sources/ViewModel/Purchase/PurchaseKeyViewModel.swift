//
//  PurchaseKeyViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa


class PurchaseKeyViewModel: NSObject {
  
  
  
  override init() {
    super.init()
    GADRewardBasedVideoAd.sharedInstance().delegate = self
    
    GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
  }
}

extension PurchaseKeyViewModel: GADRewardBasedVideoAdDelegate{
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
