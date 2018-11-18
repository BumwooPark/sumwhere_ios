//
//  OneTimeMatchViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 16/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import MXParallaxHeader
import RxSwift
import RxCocoa

class OneTimeMatchViewController: UIViewController, ListAdapterDataSource{
  private let disposeBag = DisposeBag()
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return [1,2,3,4] as [ListDiffable]
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return TripSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    let emptyView = MatchEmptyView(frame: UIScreen.main.bounds)
    emptyView.addButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          let tripView = CreateTripViewController()
          weakSelf.present(tripView, animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    return emptyView
  }
  
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = .white
    collectionView.register(TripTicketCell.self, forCellWithReuseIdentifier: String(describing: TripTicketCell.self))
    let emptyView = UIView()
    emptyView.backgroundColor = .blue
    collectionView.parallaxHeader.view = emptyView
    collectionView.parallaxHeader.height = UIScreen.main.bounds.height
    collectionView.parallaxHeader.minimumHeight = 10
    collectionView.parallaxHeader.mode = .fill
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
  }
}
