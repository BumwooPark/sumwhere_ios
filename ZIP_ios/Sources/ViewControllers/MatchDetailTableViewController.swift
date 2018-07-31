//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import expanding_collection
import RxSwift
import RxCocoa
import RxDataSources
import Hero

class MatchDetailTableViewController: UIViewController {
  
  fileprivate var scrollOffsetY: CGFloat = 0
  let disposeBag = DisposeBag()
  let typeImage: UIImage
  
  var heroID: String = ""
  
 
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<MatchViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MatchCell.self), for: idx) as! MatchCell
    cell.item = item
    return cell
  }, configureSupplementaryView: {[weak self] ds,cv,name,idx in
    let headerView = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: MatchHeaderView.self), for: idx) as! MatchHeaderView
    guard let `self` = self else {return headerView}
    headerView.imageView.image = self.typeImage
    headerView.imageView.hero.id = self.heroID
    return headerView
  })
  
  let sampleData = [MatchViewModel(items:[MatchTypeModel(detail: "하루에 4명 무료 매칭", title: "기본매칭", key: 0),
                                  MatchTypeModel(detail: "내 마음대로 찾는 맞춤 매칭", title: "맞춤 매칭", key: 20),
                                  MatchTypeModel(detail: "혼자가면 지루하니까", title: "말동무 매칭", key: 30),
                                  MatchTypeModel(detail: "같은 여행지 동행 매칭", title: "여행지 매칭", key: 15),
                                  MatchTypeModel(detail: "Fever Time", title: "Fever", key: 20)])]
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MatchCell.self, forCellWithReuseIdentifier: String(describing: MatchCell.self))
    collectionView.register(MatchHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: MatchHeaderView.self))
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  init(image: UIImage) {
    typeImage = image
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = collectionView
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
  
    
    hero.isEnabled = true 
//    hero.modalAnimationType = .selectBy(presenting: .auto , dismissing: .auto)
    Observable.just(sampleData)
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
}


// MARK: Actions

//extension MatchDetailTableViewController {
//
//  @IBAction func backButtonHandler(_: AnyObject) {
//    // buttonAnimation
//    popTransitionAnimation()
//  }
//}

// MARK: UIScrollViewDelegate

extension MatchDetailTableViewController {

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MatchCell.self), for: indexPath) as! MatchCell
    cell.item = sampleData[indexPath.item]
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sampleData.count
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
      popTransitionAnimation()
    }
    scrollOffsetY = scrollView.contentOffset.y
  }
}
