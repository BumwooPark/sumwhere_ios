//
//  TripViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 10..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import BubbleTransition
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import JDStatusBarNotification
import EmptyDataSet_Swift


class TripViewController: UIViewController{
  
  static var currentModel: TripModel?
  
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  private let viewModel = TripViewModel()
  
  let transition = BubbleTransition()
  let interactiveTransition = BubbleInteractiveTransition()
  let refreshControl = UIRefreshControl()
  
  private let datas = BehaviorRelay<[MyTripViewModel]>(value: [])
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<MyTripViewModel>(configureCell: {[weak self] ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TripTicketCell.self), for: idx) as! TripTicketCell
    cell.item = item
    guard let `self` = self else {return cell}
    cell.ticketView.moreButton
      .rx
      .tap
      .map{_ in return item}
      .bind(onNext: self.menuPopUp)
      .disposed(by: self.disposeBag)
    
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: 339, height: 175)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(TripTicketCell.self, forCellWithReuseIdentifier: String(describing: TripTicketCell.self))
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.emptyDataSetSource = self
    return collectionView
  }()
  
  override func loadView() {
    super.loadView()
    view = collectionView
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.topItem?.title = String()
    view.setNeedsUpdateConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    api()
    
    refreshControl.rx.controlEvent(.valueChanged)
      .subscribe {[weak self] _ in
        self?.api()
    }.disposed(by: disposeBag)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected(TripModel.self)
      .subscribe(onNext: {[weak self] model in
        TripViewController.currentModel = model
        self?.navigationController?.pushViewController(UIViewController(), animated: true)
      }).disposed(by: disposeBag)
  }
  
  func api(){
    
    viewModel.getApi
      .catchError { (error) -> PrimitiveSequence<SingleTrait, ResultModel<[TripModel]>> in
        if case .statusCode = error as! MoyaError{
          JDStatusBarNotification.show(withStatus: "관리자에게 문의바랍니다.", dismissAfter: 2, styleName: JDType.Fail.rawValue)
        }
        return Single.error(error)
      }.asObservable()
      .map{$0.result}
      .unwrap()
      .map{[MyTripViewModel(items: $0)]}
      .catchErrorJustReturn([])
      .do(onNext: {[weak self] (_) in
        self?.refreshControl.endRefreshing()
      })
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  
  func menuPopUp(item: TripModel){

    let alertController = UIAlertController(title: item.tripType.trip, message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {[weak self] (action) in
      guard let `self` = self else {return}
      self.viewModel.deleteApi(item.trip.id)
        .subscribe(onSuccess: { (model) in
          if model.success{
            JDStatusBarNotification.show(withStatus: "삭제 되었습니다.", dismissAfter: 2, styleName: JDType.Success.rawValue)
            self.api()
            self.view.layoutIfNeeded()
          }else{
            JDStatusBarNotification.show(withStatus: model.error?.details ?? "관리자에게 문의 바랍니다.", dismissAfter: 2, styleName: JDType.Fail.rawValue)
          }
      }, onError: { (error) in
        log.error(error)
      }).disposed(by: self.disposeBag)
    }))
    alertController.addAction(UIAlertAction(title: "수정", style: .default, handler: { (action) in
    }))
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
    }))
    
    self.navigationController?.present(alertController, animated: true, completion: nil)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
   
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

//extension TripViewController: UIViewControllerTransitioningDelegate{
//  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    transition.transitionMode = .present
//    transition.startingPoint = addButton.center
//    transition.bubbleColor = addButton.backgroundColor!
//    return transition
//  }
//
//  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    transition.transitionMode = .dismiss
//    transition.startingPoint = addButton.center
//    transition.bubbleColor = addButton.backgroundColor!
//    return transition
//  }
//
//  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//    return interactiveTransition
//  }
//}

extension TripViewController: EmptyDataSetSource{
  func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
    let view = MatchEmptyView(frame: UIScreen.main.bounds)
    view.addButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          let tripView = CreateTripViewController()
          weakSelf.present(tripView, animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    return view
  }
}
