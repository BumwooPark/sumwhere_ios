//
//  NewMainViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import MXParallaxHeader
import RxSwift
import RxCocoa
import RxDataSources

final class NewMainViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let viewModel: MainTypes = MainViewModel()
  private let keyStoreButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconAlarm.png"), for: .normal)
    return button
  }()
  
  private let headerView = MainHeaderView()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<CountryWithPlace>>(configureCell: {ds, cv, idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: idx) as! MainViewCell
    cell.item = item
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 334)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    collectionView.parallaxHeader.view = headerView
    collectionView.parallaxHeader.minimumHeight = 0
    collectionView.parallaxHeader.height = 461
//    collectionView.parallaxHeader.mode = .fill
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: keyStoreButton)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "taskbarMacthingNot.png").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    
    bind()
  }
  func bind(){
    viewModel.outputs
      .placeDatas
      .map{[GenericSectionModel<CountryWithPlace>(items: $0)]}
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    
    viewModel.outputs
      .eventDatas
      .map{[GenericSectionModel<EventModel>(items: $0)]}
      .bind(to: headerView.datas)
      .disposed(by: disposeBag)
  }
}
