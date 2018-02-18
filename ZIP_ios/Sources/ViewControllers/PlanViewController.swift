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
import DZNEmptyDataSet

class PlanViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  
  let data = BehaviorRelay<[PlanViewModel]>(value: [])
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
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    data.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    
    self.navigationItem.title = "계획"
  }
}

extension PlanViewController: PlanFlowLayoutDelegate{
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    return 300
  }
}

extension PlanViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return .white
  }
  

  func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    return NSAttributedString(string: "추가해보세요", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.NotoSansKRBold(size: 20)])
  }
  
  func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
    self.navigationController?.pushViewController(SetPlanViewController(), animated: true)
  }
}




