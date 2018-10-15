//
//  ReceiveViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import SkeletonView

final class MatchHistoryViewController: UIViewController{
  
  enum RequestType{
    case Receive
    case Send
  }
  
  let VCType: RequestType
  var didUpdateConstraint = false
  let viewModel = ReceiveViewModel()
  let disposeBag = DisposeBag()
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<MatchRequestHistoryViewModel>(
    configureCell: {ds,cv,idx,item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MatchHistoryCell.self), for: idx) as! MatchHistoryCell
      cell.item = item
      return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(MatchHistoryCell.self, forCellWithReuseIdentifier: String(describing: MatchHistoryCell.self))
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  let datas = BehaviorRelay<[MatchRequestHistoryViewModel]>(value: [])
  
  init(type: RequestType) {
    self.VCType = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  override func willMove(toParent parent: UIViewController?) {
    super.willMove(toParent: parent)
    api()
  }
  
  private func api(){
    switch VCType{
    case .Receive:
      viewModel
        .receiveHistoryApi()
        .map{[MatchRequestHistoryViewModel(items: $0)]}
        .bind(to: datas)
        .disposed(by: disposeBag)
      
    case .Send:
      viewModel
        .sendHistoryApi()
        .map{[MatchRequestHistoryViewModel(items: $0)]}
        .bind(to: datas)
        .disposed(by: disposeBag)
    }
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
