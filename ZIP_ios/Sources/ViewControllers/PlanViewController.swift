//
//  PlanViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 23..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class PlanViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  
  let data = BehaviorRelay(value: [])
  let dataSource = RxCollectionViewSectionedReloadDataSource<PlanViewModel>(
    configureCell:{ds,cv,index,item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: PlanCell.ID, for: index) as! PlanCell
      
      return cell
  }, configureSupplementaryView:{ds,cv,name,index in
    return UICollectionReusableView()
  })
  
  
  lazy var collectionView: UICollectionView = {
    let layout = PlanFlowLayout()
    layout.delegate = self
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(PlanCell.self, forCellWithReuseIdentifier: PlanCell.ID)
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    self.navigationItem.title = "계획"
  }
}

extension PlanViewController: PlanFlowLayoutDelegate{
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    return 300
  }
}




