//
//  OtherMyPageSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import RxSwift
import RxCocoa

class OtherMyPageSectionController: ListSectionController, ListSupplementaryViewSource{
  
  let pushSubject = PublishRelay<UIViewController>()
  var item: SupportModel?
  
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
                                        class: SupportHeaderView.self,
                                        at: index) as! SupportHeaderView
    view.title.text = item?.header
    return view
  }
  
  func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 30)
  }
  
  override func didSelectItem(at index: Int) {
    guard let vc = item?.viewControllers[index].viewController else {return}
    pushSubject.accept(vc)
    
  }
  
  override func didUpdate(to object: Any) {
    guard let item = object as? SupportModel else {return}
    self.item = item
  }
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(of: SupportCell.self, for: self, at: index) as! SupportCell
    cell.titleLabel.text = item?.viewControllers[index].name
    return cell
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 54)
  }
  
  override func numberOfItems() -> Int {
    return item?.viewControllers.count ?? 0
  }
}
