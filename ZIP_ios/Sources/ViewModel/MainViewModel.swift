//
//  MainViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 10..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

struct MainViewModel{
  var header: String
  var items: [Item]
}

extension MainViewModel: SectionModelType{
  typealias Item = MainModel
  init(original: MainViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

