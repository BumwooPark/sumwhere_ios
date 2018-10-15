//
//  MatchSelectViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 12/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit

class MatchSelectViewController: ListSectionController {
  
  let layout = UICollectionViewFlowLayout()
  let collectionView = UICollectionView()
  
  
  

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 55)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    return collectionContext!.dequeueReusableCell(of: UICollectionViewCell.self, for: self, at: index)
  }
}
