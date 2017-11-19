//
//  FeedViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

class FeedViewController: UIViewController{
  let disposeBag = DisposeBag()
  
  let datasources = RxCollectionViewSectionedReloadDataSource<FeedViewModel>(configureCell: {ds,cv,ip,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: "", for: ip) as! UICollectionViewCell
    return cell
  }, configureSupplementaryView: {ds,cv,ip,item in
    return UICollectionReusableView()
  })
  
  let mainCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view = mainCollectionView
  }
}
