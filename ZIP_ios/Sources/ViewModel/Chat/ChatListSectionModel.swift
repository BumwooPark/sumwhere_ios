//
//  ChatListSectionModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct ChatListSectionModel{
  var items: [Item]
}

extension ChatListSectionModel: SectionModelType{
  typealias Item = ChatListModel
  init(original: ChatListSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}
