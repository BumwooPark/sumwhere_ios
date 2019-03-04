////
////  TripSectionController.swift
////  ZIP_ios
////
////  Created by park bumwoo on 17/11/2018.
////  Copyright © 2018 park bumwoo. All rights reserved.
////
//
//import IGListKit
//
//class TripSectionController: ListSectionController {
//  var item: TripSectionModel?
//  
//  override func sizeForItem(at index: Int) -> CGSize {
//    return CGSize(width: 327, height: 123)
//  }
//  
//  override func cellForItem(at index: Int) -> UICollectionViewCell {
//    
//    let cell = collectionContext?.dequeueReusableCell(of: TripTicketCell.self, withReuseIdentifier: String(describing: TripTicketCell.self), for: self, at: index) as! TripTicketCell
//    cell.item = item?.datas[index]
//    return cell
//  }
//  
//  override func didUpdate(to object: Any) {
//    guard let item = object as? TripSectionModel else {return}
//    self.item = item
//  }
//  
//  override func numberOfItems() -> Int {
//    return self.item?.datas.count ?? 0
//  }
//  
//  override init() {
//    super.init()
//    minimumLineSpacing = 20
//  }
//  
//}
//
//
