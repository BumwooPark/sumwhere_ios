//
//  PurchaseHistorySectionController.swift
//  ZIP_ios
//
//  Created by xiilab on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class PurchaseHistorySectionController: ListSectionController{
  
  var item: PurchaseSectionModel?
  
  override init() {
    super.init()
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 64)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext?.dequeueReusableCell(of: PurchaseHistoryCell.self, for: self, at: index) as! PurchaseHistoryCell
    cell.item = item?.items[index]
    return cell
  }
  
  override func numberOfItems() -> Int {
    return item?.items.count ?? 0
  }
  
  override func didUpdate(to object: Any) {
    guard let item = object as? PurchaseSectionModel else {return}
    self.item = item
  }
}
