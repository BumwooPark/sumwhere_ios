//
//  MyPageViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import IGListKit

class MyPageViewController: UIViewController, ListAdapterDataSource {
  
  var items: [ListDiffable] = [SampleModel(header: "hello", title: ["알림 설정","계정 설정"]),
                              SupportModel(header: "고객지원", cellItemTitle: ["공지사항","문의하기","버젼 정보"])]
  
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    collectionView.register(MyPageHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: MyPageHeaderView.self))
    collectionView.register(SupportHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: SupportHeaderView.self))
    collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: String(describing: MyPageCell.self))
    collectionView.register(SupportCell.self, forCellWithReuseIdentifier: String(describing: SupportCell.self))
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return items
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    switch object{
    case is SampleModel:
      print(object)
      return MyPageSectionController()
    case is SupportModel:
      print(object)
      return OtherMyPageSectionController()
    default:
      return MyPageSectionController()
    }
    
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return UIView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
  }
}


class SampleModel: ListDiffable{
  
  let header: String
  let title: [String]

  init(header: String, title: [String]) {
    self.header = header
    self.title = title
  }
  
  func diffIdentifier() -> NSObjectProtocol {
    return header as NSString
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? SampleModel else {return false}
    return self.header == object.header
  }
}


class SupportModel: ListDiffable{
  
  let header: String
  let cellItemTitle: [String]
  
  init(header: String, cellItemTitle: [String]) {
    self.header = header
    self.cellItemTitle = cellItemTitle
  }
  
  func diffIdentifier() -> NSObjectProtocol {
    return header as NSObjectProtocol 
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? SampleModel else {return false}
    return self.header == object.header
  }
}
