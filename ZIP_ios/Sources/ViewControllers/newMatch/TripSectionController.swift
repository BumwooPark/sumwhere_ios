//
//  TripSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 17/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class TripSectionController: ListSectionController {
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: 339, height: 175)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext?.dequeueReusableCell(of: TripTicketCell.self, withReuseIdentifier: String(describing: TripTicketCell.self), for: self, at: index) as! TripTicketCell
    return cell
  }
  
  override func didUpdate(to object: Any) {
    guard let item = object as? DataSectionItem else {return}
  }
  
  override func numberOfItems() -> Int {
    return 0
  }
  
  override init() {
    super.init()
    self.inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
  }
  
}


