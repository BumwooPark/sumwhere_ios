//
//  MatchSelectViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 12/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class DataSectionItem: ListDiffable{
  func diffIdentifier() -> NSObjectProtocol {
    return name as NSString
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? DataSectionItem else {return false}
    return self.name == object.name
  }
  
  let name: String
  let image: UIImage
  var isSelected = false
  
  init(name: String, image: UIImage) {
    self.name = name
    self.image = image
  }
}

final class MatchSelectViewController: UIViewController, ListAdapterDataSource{
  let items = [
    
    DataSectionItem(name: "이성 매칭", image: #imageLiteral(resourceName: "bridge2.jpg") )
    ,DataSectionItem(name: "지역 매칭", image: #imageLiteral(resourceName: "boat"))
    ,DataSectionItem(name: "이동 매칭", image: #imageLiteral(resourceName: "bridge2.jpg"))
    ,DataSectionItem(name: "랜덤 매칭", image: #imageLiteral(resourceName: "bridge"))]
  
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return items as [ListDiffable]
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return MatchSelectSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.allowsMultipleSelection = true 
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    _ = adapter
  }
}
