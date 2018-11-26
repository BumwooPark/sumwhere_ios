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
  
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = .white
    collectionView.register(TripTicketCell.self, forCellWithReuseIdentifier: String(describing: TripTicketCell.self))
    
    let emptyView = UIImageView()
    emptyView.image = #imageLiteral(resourceName: "bridge")
    emptyView.contentMode = .scaleAspectFill
    collectionView.parallaxHeader.view = emptyView
    collectionView.parallaxHeader.height = UIScreen.main.bounds.height
    collectionView.parallaxHeader.minimumHeight = 0
    collectionView.parallaxHeader.mode = .fill
    collectionView.alwaysBounceVertical = true
    parallaxHeader?.delegate = self
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
    
    Observable.of(collectionView.rx.didEndDecelerating.map{_ in return ()},collectionView.rx.didEndDragging.map{_ in return ()})
      .merge()
      .observeOn(MainScheduler.asyncInstance)
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return { _ in
          if weakSelf.collectionView.contentOffset.y < -(weakSelf.collectionView.frame.height - 200){
            weakSelf.collectionView.setContentOffset(CGPoint(x: 0, y: -(weakSelf.collectionView.frame.height)), animated: true)
          }else{
            weakSelf.collectionView.setContentOffset(CGPoint.zero, animated: true)
          }
        }
    }.disposed(by: disposeBag)
  }
}


extension OneTimeMatchViewController: MXParallaxHeaderDelegate{
  func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
    log.info(parallaxHeader.progress)
  }
}
