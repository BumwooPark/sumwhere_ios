//
//  MainViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

class FeedViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return cv
  }()
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<FeedViewModel>(
    configureCell: { (ds, cv, index, model) -> UICollectionViewCell in
    return UICollectionViewCell()
  }, configureSupplementaryView: { ds,cv,index,model in
    return UICollectionReusableView()
  })
  
  var cellViewModels = BehaviorSubject<[FeedViewModel]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.view = collectionView
    self.navigationItem.title = "MAIN"
    
//    collectionView
//      .rx
//      .setDataSource(dataSources)
//      .disposed(by: disposeBag)
//
//    cellViewModels
//      .asDriver(onErrorJustReturn: [])
//      .drive(collectionView.rx.items(dataSource: dataSources))
//      .disposed(by: disposeBag)
    
  }
}

extension FeedViewController: UICollectionViewDelegate{
}
extension FeedViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let height = Int(collectionView.frame.size.height * 0.8)
    let width = Int(collectionView.frame.size.width * 0.8)
    log.info(height)
    log.info(width)
    return CGSize(width: width, height: height)
  }
}


