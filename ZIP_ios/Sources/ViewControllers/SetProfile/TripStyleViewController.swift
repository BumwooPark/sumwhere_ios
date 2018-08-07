//
//  TripStyleViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka
import DZNEmptyDataSet
import RxSwift
import RxCocoa
import RxDataSources

class TripStyleViewController: UIViewController, TypedRowControllerType{
  
  var row: RowOf<String>!
  var onDismissCallback: ((UIViewController) -> Void)?
  
  var model: [TripType]?
  private let disposeBag = DisposeBag()
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<TripStyleViewModel>(
    configureCell: {[weak self] ds,cv,idx,item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TripStyleCell.self), for: idx) as! TripStyleCell
      guard let `self` = self else {return cell}
      self.cellInit(cell: cell, item: item)
      return cell
  },configureSupplementaryView: {[weak self]ds,cv,kind,idx in
    
    switch kind{
    case UICollectionElementKindSectionHeader:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: TripStyleHeaderView.self), for: idx) as! TripStyleHeaderView
      return view
    case UICollectionElementKindSectionFooter:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: TripStyleFooterView.self), for: idx) as! TripStyleFooterView
      guard let `self` = self else {return view}
      view.commitButton
        .rx
        .tap
        .bind(onNext: self.commit)
      .disposed(by: self.disposeBag)
      return view
    default:
      return UICollectionReusableView()
    }
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
    layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.register(TripStyleCell.self, forCellWithReuseIdentifier: String(describing: TripStyleCell.self))
    collectionView.register(TripStyleHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: TripStyleHeaderView.self))
    collectionView.register(TripStyleFooterView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                            withReuseIdentifier: String(describing: TripStyleFooterView.self))
    collectionView.isPrefetchingEnabled = false
    collectionView.emptyDataSetSource = self
    collectionView.allowsMultipleSelection = true
    collectionView.delegate = self
    return collectionView
  }()
  
  init(model: [TripType]?) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    navigationItem.largeTitleDisplayMode = .never
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { index in
        log.info(index)
      }).disposed(by: disposeBag)
    
    callApi()
  }
  
  func cellInit(cell: TripStyleCell, item: TripStyleModel){
    cell.item = item
    model?.forEach({ (type) in
      if type.id == item.id{
        cell.backgroundColor = .blue
      }
    })
  }
  
  func callApi(){
    AuthManager.provider.request(.GetAllTripStyle)
      .map(ResultModel<[TripStyleModel]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
      .map{[TripStyleViewModel(items: $0)]}
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  func commit(){
    guard let dismiss = onDismissCallback else {return}
    dismiss(self)
    log.info("commit")
  }
}

extension TripStyleViewController: DZNEmptyDataSetSource{
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    return Init(UIActivityIndicatorView(activityIndicatorStyle: .gray)){
      $0.startAnimating()
    }
  }
}

extension TripStyleViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if (collectionView.indexPathsForSelectedItems?.count)! < 3 {
      return true
    }else {
      return false
    }
  }
}
