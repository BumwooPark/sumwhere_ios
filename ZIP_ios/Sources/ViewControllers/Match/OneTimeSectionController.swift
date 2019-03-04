////
////  OneTimeSectionController.swift
////  ZIP_ios
////
////  Created by xiilab on 05/12/2018.
////  Copyright © 2018 park bumwoo. All rights reserved.
////
//
//import IGListKit
//
//class OneTimeSectionController: ListSectionController {
//  var item: TripSectionModel?
//  
//  override func sizeForItem(at index: Int) -> CGSize {
//    return CGSize(width: 306, height: 380)
//  }
//  
//  override func cellForItem(at index: Int) -> UICollectionViewCell {
//    let cell = collectionContext?.dequeueReusableCell(of: OneTimeMatchSelectCell.self, for: self, at: index) as! OneTimeMatchSelectCell
//    return cell
//  }
//  
//  override func didUpdate(to object: Any) {
//    guard let item = object as? TripSectionModel else {return}
//    self.item = item
//  }
//  
//  override func numberOfItems() -> Int {
//    return 4
//  }
//  
//  override init() {
//    super.init()
//    minimumLineSpacing = 20
//  }
//}
//
//
