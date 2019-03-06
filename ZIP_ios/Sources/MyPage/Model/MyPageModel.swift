//
//  MyPageModel.swift
//  ZIP_ios
//
//  Created by xiilab on 12/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class MyPageModel: ListDiffable{
  let header: String
  let viewControllers: [PageCellDataModel]
  
  init(header: String, viewControllers: [PageCellDataModel]) {
    self.header = header
    self.viewControllers = viewControllers
  }
  
  func diffIdentifier() -> NSObjectProtocol {
    return header as NSString
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? MyPageModel else {return false}
    return self.header == object.header
  }
}
