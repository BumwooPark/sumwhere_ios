//
//  PlanTripViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 17/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import RxSwift
import RxCocoa
import MXParallaxHeader

class PlanTripViewController: UIViewController, ListAdapterDataSource {
  let viewModel: TripViewModel
  private let disposeBag = DisposeBag()
  
  var items: [TripSectionModel] = []
  
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return items
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return TripSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    let emptyView = MatchEmptyView()
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
    collectionView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    collectionView.register(TripTicketCell.self, forCellWithReuseIdentifier: String(describing: TripTicketCell.self))
    collectionView.alwaysBounceVertical = true 
    //    let emptyView = UIImageView()
    //    emptyView.image = #imageLiteral(resourceName: "bridge")
    //    emptyView.contentMode = .scaleAspectFill
    //    collectionView.parallaxHeader.view = emptyView
    //    collectionView.parallaxHeader.height = UIScreen.main.bounds.height
    //    collectionView.parallaxHeader.minimumHeight = 0
    //    collectionView.parallaxHeader.mode = .fill
    //    collectionView.alwaysBounceVertical = true
    //    parallaxHeader?.delegate = self
    return collectionView
  }()
  
  init(_ viewModel: TripViewModel){
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    log.info("willappear")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
    API()
    
    //    Observable.of(collectionView.rx.didEndDecelerating
    //      .map{_ in return ()},collectionView.rx.didEndDragging.map{_ in return ()})
    //      .merge()
    //      .observeOn(MainScheduler.asyncInstance)
    //      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
    //        return { _ in
    //          if weakSelf.collectionView.contentOffset.y < -(weakSelf.collectionView.frame.height - 200){
    //            weakSelf.collectionView.setContentOffset(CGPoint(x: 0, y: -(weakSelf.collectionView.frame.height)), animated: true)
    //          }else{
    //            weakSelf.collectionView.setContentOffset(CGPoint.zero, animated: true)
    //          }
    //        }
    //    }.disposed(by: disposeBag)
  }
  
  func API(){
    viewModel.planTripGetApi
      .elements()
      .map{[TripSectionModel(paging: 0, datas: $0)]}
      .subscribeNext(weak: self) { (weakSelf) -> ([TripSectionModel]) -> Void in
        return {models in
          weakSelf.items = models
          weakSelf.adapter.performUpdates(animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    
  }
}




extension PlanTripViewController: MXParallaxHeaderDelegate{
  func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
    
  }
}
