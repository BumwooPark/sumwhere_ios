//
//  FeedViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

struct FeedViewModel{
  var items: [Item]
}

extension FeedViewModel: SectionModelType{
  typealias Item = FeedModel
  init(original: FeedViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
