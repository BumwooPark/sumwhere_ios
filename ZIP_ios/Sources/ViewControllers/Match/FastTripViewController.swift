//
//  FastTripViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 07/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import IGListKit

class FastTripViewController: UIViewController, ListAdapterDataSource{
  
  var items: [DataSectionItem] = []
  
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return items as [ListDiffable]
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return MatchSelectSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    return collectionView
  }()
  
  let addButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
  }
}



//final class MatchSelectSectionController: ListSectionController{
//
//  var item: DataSectionItem?
//
//  override func sizeForItem(at index: Int) -> CGSize {
//    if item?.isSelected ?? false {
//      return CGSize(width: collectionContext!.containerSize.width, height: 337)
//    }else {
//      return CGSize(width: collectionContext!.containerSize.width, height: 144)
//    }
//  }
//
//  override func cellForItem(at index: Int) -> UICollectionViewCell {
//    let cell = collectionContext!.dequeueReusableCell(of: MatchSelectCell.self, for: self, at: index) as! MatchSelectCell
//    cell.item = item
//    return cell
//  }
//  
//  override func didUpdate(to object: Any) {
//
//    guard let item = object as? DataSectionItem else {return}
//    self.item = item
//  }
//
//  override func numberOfItems() -> Int {
//    return 1 // One hero will be represented by one cell
//  }
//  //  337
//
//  override func didDeselectItem(at index: Int) {
//    self.item?.isSelected = false
//    UIView.animate(withDuration: 0.5,
//                   delay: 0,
//                   usingSpringWithDamping: 0.4,
//                   initialSpringVelocity: 0.6,
//                   options: [],
//                   animations: {
//                    self.collectionContext?.invalidateLayout(for: self)
//    })
//  }
//
//  override func didSelectItem(at index: Int) {
//    self.item?.isSelected = true
//    UIView.animate(withDuration: 0.5,
//                   delay: 0,
//                   usingSpringWithDamping: 0.4,
//                   initialSpringVelocity: 0.6,
//                   options: [],
//                   animations: {
//                    self.collectionContext?.invalidateLayout(for: self)
//    })
//  }
//}
//
