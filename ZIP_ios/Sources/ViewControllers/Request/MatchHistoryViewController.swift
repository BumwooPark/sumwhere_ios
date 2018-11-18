//
//  ReceiveViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import IGListKit
import SkeletonView

enum RequestType{
  case Receive
  case Send
}

final class MatchHistoryViewController: UIViewController, ListAdapterDataSource{
  private let disposeBag = DisposeBag()
  
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  let VCType: RequestType
  var didUpdateConstraint = false
  let viewModel = ReceiveViewModel()

  
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.register(MatchHistoryCell.self, forCellWithReuseIdentifier: String(describing: MatchHistoryCell.self))
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  let datas = BehaviorRelay<[MatchRequestHistoryViewModel]>(value: [])
  
  init(type: RequestType) {
    self.VCType = type
    super.init(nibName: nil, bundle: nil)
  }
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return [1,2] as [ListDiffable]
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return ReceiveHistorySectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
  }
  
  override func willMove(toParent parent: UIViewController?) {
    super.willMove(toParent: parent)
    api()
  }
  
  private func api(){
    switch VCType{
    case .Receive:
      viewModel
        .receiveHistoryApi()
        .map{[MatchRequestHistoryViewModel(items: $0)]}
        .bind(to: datas)
        .disposed(by: disposeBag)
      
    case .Send:
      viewModel
        .sendHistoryApi()
        .map{[MatchRequestHistoryViewModel(items: $0)]}
        .bind(to: datas)
        .disposed(by: disposeBag)
    }
  }
}
