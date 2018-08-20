//
//  ResultMatchController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

final class MatchResultController: UIViewController{
  
  var didUpdateContraint = false
  let disposeBag = DisposeBag()
  
  let viewModel = RelationShipViewModel()
  
  let datas = BehaviorRelay<[MatchResultViewModel]>(value: [])
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<MatchResultViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MatchResultCell.self), for: idx) as! MatchResultCell
    return cell
  })
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(UINib(nibName: "MatchResultCell", bundle:nil), forCellWithReuseIdentifier: String(describing: MatchResultCell.self))
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    viewModel.api(tripId: 1, startDate: "2018-08-01", endDate: "2018-09-30")
        
    view.setNeedsUpdateConstraints()
  }

  override func updateViewConstraints() {
    if !didUpdateContraint{
      didUpdateContraint = true
    }
    
    super.updateViewConstraints()
  }
}
