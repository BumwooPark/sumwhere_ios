//
//  InfoPageViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 12/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import IGListKit

class InfoPageViewController: UIViewController, ListAdapterDataSource {
  private let viewModel = EventInfoViewModel()
  private let disposeBag = DisposeBag()
  
  var items: [NoticeSectionModel] = []
  
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
    return InfoPageSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
    
    viewModel.InfoAPI
      .elements()
      .map{$0.map({ (model) -> NoticeSectionModel in
        NoticeSectionModel(data: model)
      })}
      .subscribeNext(weak: self) { (weakSelf) -> ([NoticeSectionModel]) -> Void in
        return {models in
          weakSelf.items = models
          weakSelf.adapter.performUpdates(animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    viewModel.InfoAPI.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
        }
      }.disposed(by: disposeBag)
  }
}
