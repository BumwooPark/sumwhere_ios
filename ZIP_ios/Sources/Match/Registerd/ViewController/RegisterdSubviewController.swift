//
//  RegisterdSubviewController.swift
//  ZIP_ios
//
//  Created by xiilab on 29/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//


import RxDataSources
import RxCocoa
import RxSwift

enum TripSelectorType{
  case date(icon: UIImage, start: String, end: String)
  case comment(icon: UIImage, title: String)
}

class RegisterdSubviewController: UIViewController, UICollectionViewDelegateFlowLayout{
  private let disposeBag = DisposeBag()
  
  let data = PublishRelay<TripModel>()
  lazy var selectAction = collectionView.rx.modelSelected(TripSelectorType.self).share()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<TripSelectorType>>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(
      withReuseIdentifier: String(describing: RegisterdSubviewCell.self), for: idx) as! RegisterdSubviewCell
    cell.item = item
    return cell
  })
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = CGSize(width: 100, height: 30)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(RegisterdSubviewCell.self, forCellWithReuseIdentifier: String(describing: RegisterdSubviewCell.self))
    collectionView.backgroundColor = .white
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    collectionView.alwaysBounceHorizontal = true
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()
  
  override func loadView() {
    super.loadView()
    view = collectionView
    
    data.flatMapLatest { (model) in
      return Observable<[TripSelectorType]>
        .just([.date(icon: #imageLiteral(resourceName: "currentTimeIcon.png"), start: model.trip.startDate,end: model.trip.endDate),
               .comment(icon: #imageLiteral(resourceName: "commentImage.png"), title: model.trip.activity)])
      }.map{[GenericSectionModel<TripSelectorType>(items: $0)]}
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
  }
}
