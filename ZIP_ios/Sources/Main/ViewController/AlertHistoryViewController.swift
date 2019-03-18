//
//  AlertHistoryViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 25/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa
import RxDataSources

class AlertHistoryViewController: UIViewController{
  private var isDismissPossible = false
  private let disposeBag = DisposeBag()
  private let datas = BehaviorRelay<[GenericSectionModel<AlertHistory>]>(value: [])
  
  private let cancelBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "imagecancel"), style: .plain, target: nil, action: nil)
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<AlertHistory>>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: AlertHistoryCell.self), for: idx) as! AlertHistoryCell
    cell.item = item
    return cell
  })
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 87)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(AlertHistoryCell.self, forCellWithReuseIdentifier: String(describing: AlertHistoryCell.self))
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    title = "알림"
    self.navigationItem.leftBarButtonItem = cancelBarButton
    cancelBarButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.dismiss(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
    
    API()
    bind()
  }
  
  func bind(){
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  func API(){
    let result = AuthManager.instance.provider.request(.GetPushHistory)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[AlertHistory]>.self)
      .map{$0.result ?? []}
      .map{[GenericSectionModel<AlertHistory>(items: $0)]}
      .asObservable()
      .materialize()
      .share()
    
    result.elements()
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    result.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
        }
      }.disposed(by: disposeBag)
  }
}
