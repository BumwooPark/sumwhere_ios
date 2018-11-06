//
//  PurchaseViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import StoreKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct PurchaseViewModel{
  var title: String
  var items: [SKProduct]
}

extension PurchaseViewModel: SectionModelType{
  typealias Item = SKProduct
  init(original: PurchaseViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

