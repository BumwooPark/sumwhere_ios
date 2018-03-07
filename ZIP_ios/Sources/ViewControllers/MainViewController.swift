//
//  MainViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 10..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum MainButtonEvent{
  case Travel
  case Meet
  case none
}

class MainViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let provider = AuthManager.provider
  private let leftBarItem: UIBarButtonItem = {
    let label = UILabel()
    label.text = "여행갈래?"
    label.font = UIFont.NotoSansKRBold(size: 22)
    return UIBarButtonItem(customView: label)
  }()
  
  let eventAction: PublishSubject = PublishSubject<MainButtonEvent>()
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<MainViewModel>(
    configureCell: {(ds, cv, idx, item) -> UICollectionViewCell in
      
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainCell.self), for: idx) as! MainCell
    return cell
  },configureSupplementaryView:{ (ds,cv,name,idx) in
    let view = cv.dequeueReusableSupplementaryView(
      ofKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: String(describing: MainHeaderView.self),
      for: idx) as! MainHeaderView
    view.mainViewController = self
    return view
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MainCell.self, forCellWithReuseIdentifier: String(describing: MainCell.self))
    collectionView.register(MainHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: MainHeaderView.self))
    
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    return collectionView
  }()
  
  
  override func loadView(){
    super.loadView()
    navigationBarInit()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    Observable.of([MainViewModel(items: [MainModel(title: "123"),MainModel(title: "2"),MainModel(title: "2"),MainModel(title: "2")]),
                   MainViewModel(items: [MainModel(title: "2"),MainModel(title: "2"),MainModel(title: "2"),MainModel(title: "2")]),
                   MainViewModel(items: [MainModel(title: "2")])])
        .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    
    eventAction
      .asDriver(onErrorJustReturn: .none)
      .drive(onNext: {[weak self] (type) in
        switch type{
        case .Travel:
          self?.navigationController?.pushViewController(PlanViewController(), animated: true)
        case .Meet,.none:
          break
        }
      }).disposed(by: disposeBag)
  }
  
  private func navigationBarInit(){
    self.navigationController?
      .navigationBar
      .setBackgroundImage(
        UIImage.resizable().color(.white).image, for: UIBarMetrics.default
    )
    self.navigationItem.leftBarButtonItem = leftBarItem
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    return (section == 0) ? CGSize(width: UIScreen.main.bounds.width, height: 350) : .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width/2, height: 300)
  }
}
