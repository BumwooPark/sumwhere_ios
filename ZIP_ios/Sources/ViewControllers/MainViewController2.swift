//
//  MainViewController2.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import expanding_collection

class MainViewController2: ExpandingViewController{
  var item: [String] = ["1","2","3"]
  override func viewDidLoad() {
    itemSize = CGSize(width: 214, height: 460)
    
    
    
    collectionView?.register(MainViewCell.self, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
  }
}
extension MainViewController2:UICollectionViewDataSource {
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: indexPath) as! MainViewCell
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    cell.cellIsOpen(!cell.isOpened)
  }
}

