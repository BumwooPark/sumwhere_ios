//
//  ReceiveHistoryViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 01/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import EmptyDataSet_Swift

final class HistoryViewController: UIViewController{
  
  private let viewModel: MatchHistoryTypes
  private let disposeBag = DisposeBag()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<HistorySectionModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: HistoryCell.self), for: idx) as! HistoryCell
    return cell
  },configureSupplementaryView: {ds,cv,kind,idx in
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let view = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HistoryHeaderView.self), for: idx) as! HistoryHeaderView
      view.item = ds[idx.section].tripPlaceJoind
      return view
    case UICollectionView.elementKindSectionFooter:
      let view = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HistoryFooterView.self), for: idx) as! HistoryFooterView
      return view
    default:
      return UICollectionReusableView()
    }
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(HistoryHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: HistoryHeaderView.self))
    collectionView.register(HistoryCell.self,
                            forCellWithReuseIdentifier: String(describing: HistoryCell.self))
    collectionView.register(HistoryFooterView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: String(describing: HistoryFooterView.self))
    collectionView.emptyDataSetSource = self
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  init(viewModel: MatchHistoryTypes) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.view = collectionView
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.inputs.getHistoryData()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func bind(){
    
    viewModel.outputs
      .historyData
      .asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
}

extension HistoryViewController: EmptyDataSetSource{
  func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
    return HistoryReceiveEmptyView()
  }
}
