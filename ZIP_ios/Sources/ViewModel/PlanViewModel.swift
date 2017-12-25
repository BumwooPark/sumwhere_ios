//
//  PlanViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 24..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

struct PlanViewModel{
  var items: [Item]
}

extension PlanViewModel: SectionModelType{
  typealias Item = PlanModel
  init(original: PlanViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

