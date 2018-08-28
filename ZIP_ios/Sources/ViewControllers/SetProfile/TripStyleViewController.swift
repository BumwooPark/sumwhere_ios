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
  
  
  let datas = BehaviorRelay<[TripStyleViewModel]>(value: [])
  var viewModel: ProfileViewModel
  var selectModel: [TripStyleModel] = []
  var selectedModel: [TripStyleModel] = []
  private let disposeBag = DisposeBag()
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<TripStyleViewModel>(
    configureCell: {[weak self] ds,cv,idx,item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TripStyleCell.self), for: idx) as! TripStyleCell
      cell.item = item
      if let `self` = self {
        for model in self.selectModel{
          cell.isSelected = (model.id == item.id) ? true : false
        }
      }
      return cell
  },configureSupplementaryView: {[weak self]ds,cv,kind,idx in
    
    switch kind{
    case UICollectionElementKindSectionHeader:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: TripStyleHeaderView.self), for: idx) as! TripStyleHeaderView
      return view
    case UICollectionElementKindSectionFooter:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: TripStyleFooterView.self), for: idx) as! TripStyleFooterView
      guard let `self` = self else {return view}
      
      if self.collectionView.indexPathsForSelectedItems?.count == 0{
        view.commitButton.isEnabled = false
        view.commitButton.bgColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      }else{
        view.commitButton.isEnabled = true
        view.commitButton.bgColor = #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)
      }
      
      view.commitAction
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
  
  init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    navigationItem.largeTitleDisplayMode = .never
    
    let selected = collectionView.rx.modelSelected(TripStyleModel.self)
    let deselected = collectionView.rx.modelDeselected(TripStyleModel.self)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    Observable.combineLatest(datas.asObservable(), viewModel.getTripType) {$1}
      .subscribe(onNext: {[weak self] (model) in
        guard let `self` = self else {return}
        self.selectModel = model
        self.collectionView.reloadData()
      }).disposed(by: disposeBag)

    Observable.of(selected,deselected).merge()
      .map{_ in return ()}
      .bind(onNext: collectionViewFooterButtonSetting)
      .disposed(by: disposeBag)
    
    selected
      .subscribe(onNext: {[weak self] (model) in
        guard let `self` = self else {return}
        self.selectedModel.append(model)
      }).disposed(by: disposeBag)
    
    deselected
      .subscribe(onNext: {[weak self] (model) in
        guard let `self` = self else {return}
        for (i,item) in self.selectedModel.enumerated(){
          if item.id == model.id{
            self.selectedModel.remove(at: i)
          }
        }
      }).disposed(by:disposeBag)
    
    callApi()
  }
  
  private func collectionViewFooterButtonSetting(){
    guard let view = collectionView
      .supplementaryView(forElementKind: UICollectionElementKindSectionFooter,
                         at: IndexPath(row: 0, section: 0)) as? TripStyleFooterView else {return}
    if collectionView.indexPathsForSelectedItems?.count == 0{
      view.commitButton.isEnabled = false
      view.commitButton.bgColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }else{
      view.commitButton.isEnabled = true
      view.commitButton.bgColor = #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)
    }
  }
  
  func callApi(){
    AuthManager.instance
      .provider.request(.GetAllTripStyle)
      .map(ResultModel<[TripStyleModel]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
      .map{[TripStyleViewModel(items: $0)]}
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  func commit(){
    guard let dismiss = onDismissCallback else {return}
    dismiss(self)
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
