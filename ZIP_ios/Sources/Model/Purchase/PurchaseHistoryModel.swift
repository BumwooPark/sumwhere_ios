//
//  PurchaseHistoryModel.swift
//  ZIP_ios
//
//  Created by xiilab on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class PurchaseSectionModel:ListDiffable{
  let section: Int
  let items: [PurchaseHistoryModel]
  
  init(section: Int, items: [PurchaseHistoryModel]) {
    self.section = section
    self.items = items
  }
  
  func diffIdentifier() -> NSObjectProtocol {
    return section as NSNumber
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? PurchaseSectionModel else {return false}
    return self.section == object.section
  }
}

struct PurchaseHistoryModel: Codable{
  let id: Int
  let user_id: Int
  let message: String
  let positive_value: Bool
  let key: Int
  let create_at: String
}
