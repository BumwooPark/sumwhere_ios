//
//  TopTripViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class TopTripViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  
  let datas = BehaviorRelay<[TopTripViewModel]>(value: [])
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<TopTripViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TopTripCell.self), for: idx) as! TopTripCell
    return cell
  })
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 476)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UINib(nibName: "TopTripCell", bundle: nil), forCellWithReuseIdentifier: String(describing: TopTripCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    return collectionView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "최다 등록 여행지"
    label.font = .AppleSDGothicNeoSemiBold(size: 19)
    return label
  }()
  
  override func loadView() {
    super.loadView()
    view = collectionView
    
    navigationItem.titleView = titleLabel
    
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    
    Observable.just([TopTripViewModel(items: [TopTripModel(name: "hi")])])
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
