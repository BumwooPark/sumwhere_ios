//
//  CountryViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 3. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

struct CountryViewModel{
  var items: [Item]
}

extension CountryViewModel: SectionModelType{
  typealias Item = CountryModel.Result
  init(original: CountryViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
