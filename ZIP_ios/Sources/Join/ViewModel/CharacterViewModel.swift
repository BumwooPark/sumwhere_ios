//
//  CharacterViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct CharacterViewModel{
  var items: [Item]
}

extension CharacterViewModel: SectionModelType{
  typealias Item = CharacterModel
  init(original: CharacterViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
