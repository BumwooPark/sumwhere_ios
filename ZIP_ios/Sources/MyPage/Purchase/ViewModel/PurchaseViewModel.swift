//
//  PurchaseViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 22/11/2018.
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
  var items: [NSObject]
}
extension PurchaseViewModel: SectionModelType{
  typealias Item = NSObject
  init(original: PurchaseViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
