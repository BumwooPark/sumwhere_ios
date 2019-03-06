//
//  AlertHistoryViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 25/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa
import RxDataSources

class AlertHistoryViewController: UIViewController{
  
//  let dataSources = RxCollectionViewSectionedReloadDataSource<AlertHistoryViewModel>(configureCell: {ds,cv,idx,item in
//    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: AlertHistoryCell.self), for: idx) as! AlertHistoryCell
//    return cell
//  })
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 87)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(AlertHistoryCell.self, forCellWithReuseIdentifier: String(describing: AlertHistoryCell.self))
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
  }
}
