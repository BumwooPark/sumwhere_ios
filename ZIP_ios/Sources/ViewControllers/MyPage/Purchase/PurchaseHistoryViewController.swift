//
//  PurchaseHistoryViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class PurchaseHistoryViewController: UIViewController, ListAdapterDataSource{
  
  var item: [PurchaseSectionModel]?
  lazy var viewModel = PurchaseHistoryViewModel(targetViewController: self)
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.register(PurchaseHistoryCell.self, forCellWithReuseIdentifier: String(describing: PurchaseHistoryCell.self))
    collectionView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    collectionView.alwaysBounceVertical = true 
    return collectionView
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "이용내역"
    view = collectionView
    _ = adapter
    _ = viewModel
  }
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return item ?? []
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return PurchaseHistorySectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}
