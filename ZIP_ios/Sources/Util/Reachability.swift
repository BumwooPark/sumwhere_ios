//
//  Reach.swift
//  ZIP_ios
//
//  Created by xiilab on 22/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa


final class Reachability {
  static let shared = Reachability()
  
  /// Monitors general network reachability.
  let reachability = NetworkReachabilityManager()
  
  var didBecomeReachable: Signal<Void> { return _didBecomeReachable.asSignal() }
  private let _didBecomeReachable = PublishRelay<Void>()
  
  init() {
    if let reachability = self.reachability {
      reachability.listener = { [weak self] in
        self?.update($0)
      }
      reachability.startListening()
    }
  }
  
  private func update(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) {
    if case .reachable = status {
      _didBecomeReachable.accept(())
    }
  }
}
