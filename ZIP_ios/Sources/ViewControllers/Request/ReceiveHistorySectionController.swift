//
//  MatchHistorySectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 18/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class ReceiveHistorySectionController: ListSectionController {
  
  override func numberOfItems() -> Int {
    return 1
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext?.containerSize.width ?? 200, height: 375)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext?.dequeueReusableCell(of: MatchHistoryCell.self, withReuseIdentifier: String(describing: MatchHistoryCell.self), for: self, at: index) as! MatchHistoryCell
    return cell
  }
  
  override func didUpdate(to object: Any) {
  }
  
}
