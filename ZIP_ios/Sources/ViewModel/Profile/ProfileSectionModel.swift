//
//  ProfileSectionModel.swift
//  ZIP_ios
//
//  Created by xiilab on 21/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxDataSources

enum ProfileSectionModel {
  case CharacterSection(name: String,items: [ProfileSectionItem])
  case StyleSection(name: String,items: [ProfileSectionItem])
  case DetailStyleSection(icon: UIImage, title: String ,item: [ProfileSectionItem])
}

enum ProfileSectionItem {
  case CharacterSectionItem(item: UserWithProfile)
  case StyleSectionItem(item: UserWithProfile)
  case DetailStyleSectionItem(item: TripStyle)
}

extension ProfileSectionModel: SectionModelType {
  typealias Item = ProfileSectionItem
  
  var items: [ProfileSectionItem] {
    switch  self {
    case .CharacterSection(name: _ ,items: let items):
      return items.map {$0}
    case .StyleSection(name: _, items: let items):
      return items.map {$0}
    case .DetailStyleSection(icon: _, title: _, item: let items):
      return items.map {$0}
    }
  }
  
  init(original: ProfileSectionModel, items: [Item]) {
    switch original {
    case .CharacterSection(let name, _):
      self = .CharacterSection(name: name, items: items)
    case .StyleSection(let name, _):
      self = .StyleSection(name: name, items: items)
    case .DetailStyleSection(let icon, let title, _):
      self = .DetailStyleSection(icon: icon, title: title, item: items)
    }
  }
}


extension ProfileSectionModel {
  var name: String {
    switch self {
    case .CharacterSection(name: let name, items: _):
      return name
    case .StyleSection(name: let name, items: _):
      return name
    case .DetailStyleSection(item: _):
      return ""
    }
  }
  
  var iconTitle: (UIImage,String)?{
    switch self {
    case .CharacterSection(name: _, items: _):
      return nil
    case .StyleSection(name: _, items: _):
      return nil
    case .DetailStyleSection(let icon,let title, item: _):
      return (icon,title)
    }
  }
}
