//
//  MyPageSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class MyPageSectionController: ListSectionController, ListSupplementaryViewSource{
  
  var item: SampleModel?
  
  override init() {
    super.init()
    supplementaryViewSource = self
  }
  func supportedElementKinds() -> [String] {
    return [UICollectionView.elementKindSectionHeader]
  }
  
  func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
    let view = collectionContext?
      .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                        for: self,
                                        class: MyPageHeaderView.self,
                                        at: index) as! MyPageHeaderView
    return view
  }
  
  func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 300)
  }
  
  override func didUpdate(to object: Any) {
    guard let item = object as? SampleModel else {return}
    self.item = item
  }
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(of: MyPageCell.self, for: self, at: index) as! MyPageCell
    cell.titleLabel.text = item?.title[index]
    return cell
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 64)
  }
  
  override func numberOfItems() -> Int {
    return 2
  }
}
