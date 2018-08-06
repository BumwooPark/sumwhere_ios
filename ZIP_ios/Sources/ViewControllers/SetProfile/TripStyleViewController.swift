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
  
  private let disposeBag = DisposeBag()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<TripStyleViewModel>(
    configureCell: {ds,cv,idx,item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TripStyleCell.self), for: idx) as! TripStyleCell
      cell.item = item
      return cell
  },configureSupplementaryView: {ds,cv,name,idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: TripStyleHeaderView.self), for: idx) as! TripStyleHeaderView
    return view
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.register(TripStyleCell.self, forCellWithReuseIdentifier: String(describing: TripStyleCell.self))
    collectionView.register(TripStyleHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: TripStyleHeaderView.self))
    collectionView.emptyDataSetSource = self
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    navigationItem.largeTitleDisplayMode = .never
    callApi()
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
}

extension TripStyleViewController: DZNEmptyDataSetSource{
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    return Init(UIActivityIndicatorView(activityIndicatorStyle: .gray)){
      $0.startAnimating()
    }
  }
}
