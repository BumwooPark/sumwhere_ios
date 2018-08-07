//
//  CharacterViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka
import TagListView
import RxSwift
import RxCocoa
import RxDataSources
import DZNEmptyDataSet
import RxSwiftExt


class InterestSelectViewController: UIViewController, TypedRowControllerType{
  
  var didUpdateConstraint = false
  var row: RowOf<String>!
  var onDismissCallback: ((UIViewController) -> Void)?
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<InterestViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: InterestCell.self), for: idx) as! InterestCell
    cell.titleLabel.text = item.typeName
    return cell
  },configureSupplementaryView: {[weak self] ds,cv,name,idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter,
                                                   withReuseIdentifier: String(describing: InterestAddView.self),
                                                   for: idx) as! InterestAddView
    
    guard let `self` = self else {return view}
    view.plusButton.rx.tap
      .bind(onNext: self.showAlertView)
      .disposed(by: self.disposeBag)
    
    return view
  })
  
  private let datas = BehaviorRelay<[InterestViewModel]>(value: [])
  private let disposeBag = DisposeBag()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 10
    layout.minimumLineSpacing = 10
    layout.estimatedItemSize = CGSize(width: 100, height: 50)
    layout.footerReferenceSize = CGSize(width: 200, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    collectionView.register(InterestCell.self, forCellWithReuseIdentifier: String(describing: InterestCell.self))
    collectionView.register(InterestAddView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                            withReuseIdentifier: String(describing: InterestAddView.self))
    
    collectionView.emptyDataSetSource = self
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    view.setNeedsUpdateConstraints()
    navigationItem.largeTitleDisplayMode = .never
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
//    
//    collectionView.rx.itemSelected
//      .subscribe(onNext: {[weak self] index in
//        self?.collectionView.cellForItem(at: index)?.isSelected = true
//      }).disposed(by: disposeBag)
//    
//    collectionView.rx.itemDeselected
//      .subscribe(onNext: {[weak self] index in
//        self?.collectionView.cellForItem(at: index)?.isSelected = false
//      }).disposed(by: disposeBag)
    
    
    
//    collectionView.rx.modelSelected(InterestModel.self)
//      .filter {$0.isAdd}
//      .subscribe { (_) in
    
    
    
    api()
  }
  
  //MARK: - NetWork
  func api(){
    AuthManager.provider.request(.GetAllInterest)
      .map(ResultModel<[InterestModel]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
      .map{[InterestViewModel(items: $0)]}
      .catchErrorJustReturn([])
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  //MARK: - Alert Action
  func showAlertView(){
    log.info(collectionView.numberOfSections)
    let vc = UIAlertController(title: "관심사 입력", message: nil, preferredStyle: .alert)
    vc.addTextField { (field) in
      field.font = UIFont.BMJUA(size: 14)
      field.placeholder = "ex) 여행"
    }
    vc.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    vc.addAction(UIAlertAction(title: "등록", style: .default, handler: {[weak self](action) in
      guard let `self` = self,let textValue = vc.textFields?.first?.text else {return}
      var section = self.datas.value[0]
      section.items.append(InterestModel(id: 0, typeName: textValue))
      Observable.just([section])
        .bind(to: self.datas)
        .disposed(by: self.disposeBag)
    }))
    
    self.present(vc, animated: true, completion: nil)
  }
}

extension InterestSelectViewController: DZNEmptyDataSetSource{
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    return Init(UIActivityIndicatorView(activityIndicatorStyle: .gray)){
      $0.startAnimating()
    }
  }
}
