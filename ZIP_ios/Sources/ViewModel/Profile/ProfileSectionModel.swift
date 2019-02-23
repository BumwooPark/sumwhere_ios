//
//  ProfileSectionModel.swift
//  ZIP_ios
//
//  Created by xiilab on 21/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxDataSources

enum ProfileSectionModel {
  case CharacterSection(items: [ProfileSectionItem])
  case StyleSection(items: [ProfileSectionItem])
  case DetailStyleSection(item: [ProfileSectionItem])
}

enum ProfileSectionItem {
  case CharacterSectionItem(item: UserWithProfile)
  case StyleSectionItem(item: UserWithProfile)
  case DetailStyleSectionItem(item: UserWithProfile)
}

extension ProfileSectionModel: SectionModelType {
  typealias Item = ProfileSectionItem
  
  var items: [ProfileSectionItem] {
    switch  self {
    case .CharacterSection(items: let items):
      return items.map {$0}
    case .StyleSection(items: let items):
      return items.map {$0}
    case .DetailStyleSection(item: let items):
      return items.map {$0}
    }
  }
  
  init(original: ProfileSectionModel, items: [Item]) {
    switch original {
    case .CharacterSection:
      self = .CharacterSection(items: items)
    case .StyleSection:
      self = .StyleSection(items: items)
    case .DetailStyleSection:
      self = .DetailStyleSection(item: items)
    }
  }
}
