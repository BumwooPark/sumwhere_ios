//
//  FriendsViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 29..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct FriendsViewModel{
  var items: [Item]
}

extension FriendsViewModel: SectionModelType{
  typealias Item = FriendsModel
  init(original: FriendsViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
