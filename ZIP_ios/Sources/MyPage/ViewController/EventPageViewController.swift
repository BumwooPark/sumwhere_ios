//
//  EventPageViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 12/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//


import IGListKit
import RxSwift
import RxCocoa
import Moya

class EventPageViewController: UIViewController, ListAdapterDataSource {
  private let viewModel = EventInfoViewModel()
  private let disposeBag = DisposeBag()
  
  var items: [EventSectionModel] = []{
    didSet{
      log.info(items[0].data)
    }
  }
  
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
    return EventSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
  
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = .white
    collectionView.register(TripTicketCell.self, forCellWithReuseIdentifier: String(describing: TripTicketCell.self))
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
    
    
    viewModel.eventAPI.elements()
      .map({ (model) -> [EventSectionModel] in
        return model.map({ (model) -> EventSectionModel in
          EventSectionModel(data: model)
        })
      })
      .subscribeNext(weak: self) { (weakSelf) -> ([EventSectionModel]) -> Void in
        return {models in
          weakSelf.items = models
          weakSelf.adapter.reloadData(completion: nil)
        }
    }.disposed(by: disposeBag)
    
    viewModel.eventAPI.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
        }
      }.disposed(by: disposeBag)
  }
}
