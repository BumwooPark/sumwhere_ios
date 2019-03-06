//
//  InfoPageSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 20/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import IGListKit
import RxSwift

class InfoPageSectionController: ListSectionController, ListSupplementaryViewSource {
  
  var disposeBag = DisposeBag()
  
  
  func supportedElementKinds() -> [String] {
    return [UICollectionView.elementKindSectionHeader]
  }
  
  func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
    let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: String(describing: NoticeHeaderView.self), for: self, class: NoticeHeaderView.self, at: index) as! NoticeHeaderView
    view.item = item
    
    view.rx.tapGesture()
      .when(.ended)
      .subscribeNext(weak: self) { (weakSelf) -> (UITapGestureRecognizer) -> Void in
        return {_ in
          guard let item = weakSelf.item else {return}
          item.isOpen = item.isOpen ? false : true
          weakSelf.collectionContext?.performBatch(animated: true, updates: {[unowned self] (context) in
            context.reload(self)
          }, completion: nil)
        }
    }.disposed(by: disposeBag)
    
    return view
  }
  
  func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 95)
  }
  
  var item: NoticeSectionModel?
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: (collectionContext?.containerSize.width)!, height: 222)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    
    let cell = collectionContext?.dequeueReusableCell(of: NoticeContentCell.self, withReuseIdentifier: String(describing: NoticeContentCell.self), for: self, at: index) as! NoticeContentCell
    cell.item = item
    return cell
  }
  
  override func didUpdate(to object: Any) {
    guard let item = object as? NoticeSectionModel else {return}
    self.disposeBag = DisposeBag()
    self.item = item
  }
  
  override func numberOfItems() -> Int {
    return (item?.isOpen ?? false) ? 1 : 0
  }
  
  override init() {
    super.init()
    minimumLineSpacing = 20
    supplementaryViewSource = self
  }
  
}



