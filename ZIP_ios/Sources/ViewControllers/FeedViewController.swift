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
    cv.register(SampleCell.self, forCellWithReuseIdentifier: SampleCell.id)
    return cv
  }()
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<FeedViewModel>(
    configureCell: { (ds, cv, index, model) -> UICollectionViewCell in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: SampleCell.id, for: index) as! SampleCell
      return cell
  }, configureSupplementaryView: { ds,cv,index,model in
    return UICollectionReusableView()
  })
  
  let cellViewModels = Variable<[FeedViewModel]>([])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view = collectionView
    self.navigationItem.title = "MAIN"
    
    cellViewModels
      .asObservable()
      .observeOn(MainScheduler.instance)
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
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

class SampleCell: UICollectionViewCell{
  static let id = "sample"
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


