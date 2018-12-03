//
//  TripSectionModel.swift
//  ZIP_ios
//
//  Created by xiilab on 03/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class TripSectionModel: ListDiffable{
  func diffIdentifier() -> NSObjectProtocol {
    return paging as NSNumber
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? TripSectionModel else {return false}
    return self.paging == object.paging
  }
  
  let paging: Int
  let datas: [TripModel]
  
  init(paging: Int, datas: [TripModel]) {
    self.paging = paging
    self.datas = datas
  }
}
