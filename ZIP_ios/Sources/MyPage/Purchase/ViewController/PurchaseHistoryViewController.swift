//
//  PurchaseHistoryViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import RxSwift


class PurchaseHistoryViewController: UIViewController, ListAdapterDataSource{
  
  var item: [ListDiffable]?
  var loading = false
  let spinToken = "spinner"
  
  private let disposeBag = DisposeBag()
  lazy var viewModel = PurchaseHistoryViewModel(targetViewController: self)
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    collectionView.rx.willEndDragging
      .filter{[unowned self] _ in !self.loading}
      .subscribeNext(weak: self) { (weakSelf) -> ((velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)) -> Void in
        return { data in
          let distance = weakSelf.collectionView.contentSize.height - (data.targetContentOffset.pointee.y + weakSelf.collectionView.bounds.height)
          if distance < 200 {
            weakSelf.viewModel.next()
          }
        }
      }.disposed(by: disposeBag)
  }
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    if loading {
      item?.append(spinToken as ListDiffable)
    }
    return item ?? []
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    if let obj = object as? String, obj == spinToken {
      return spinnerSectionController()
    } else {
      return PurchaseHistorySectionController()
    }
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return PurchaseEmptyView()
  }
}
