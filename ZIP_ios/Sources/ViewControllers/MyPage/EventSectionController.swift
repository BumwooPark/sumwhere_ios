//
//  EventSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import IGListKit

class EventSectionController: ListSectionController {
  var item: EventSectionModel?
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: (collectionContext?.containerSize.width)!, height: 222)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    
    let cell = collectionContext?.dequeueReusableCell(of: EventContentCell.self, withReuseIdentifier: String(describing: EventContentCell.self), for: self, at: index) as! EventContentCell
    cell.item = item
    return cell
  }
  
  override func didUpdate(to object: Any) {
    guard let item = object as? EventSectionModel else {return}
    self.item = item
  }
  
  override func numberOfItems() -> Int {
    return 1
  }
  
  override init() {
    super.init()
    minimumLineSpacing = 20
  }
  
}


