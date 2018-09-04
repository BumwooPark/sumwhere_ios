//
//  ChatFlowLayout.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit

import AsyncDisplayKit

protocol ChatCollectionViewLayoutDelegate: ASCollectionDelegate {
  func collectionView(_ collectionView: UICollectionView, originalItemSizeAtIndexPath: IndexPath) -> CGSize
}

final class ChatFlowLayout: UICollectionViewFlowLayout{
  private var cache = [UICollectionViewLayoutAttributes]()
  private var topPadding: CGFloat = 10
  private var bottomPadding: CGFloat = 10
  
  public var delegate: ChatCollectionViewLayoutDelegate!
  
  override init() {
    super.init()
    self.scrollDirection = .vertical
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepare() {
    super.prepare()
    cache.removeAll()
    guard let collectionView = self.collectionView else {return}
    
    
    var containerHeight: CGFloat = collectionView.frame.size.height
    containerHeight -= collectionView.contentInset.top
    containerHeight -= collectionView.contentInset.bottom
    let container = CGRect(x: collectionView.contentOffset.x,
                           y: collectionView.contentOffset.y,
                           width: collectionView.frame.size.width,
                           height: containerHeight)
    var yOffset: CGFloat = 0
    for section in 0 ..< collectionView.numberOfSections {
      let numberOfItems = collectionView.numberOfItems(inSection: section)
      for item in 0 ..< numberOfItems {
        let indexPath = IndexPath(item: item, section: section)
        
        let cellHeight = delegate.collectionView(collectionView, originalItemSizeAtIndexPath: indexPath)
        
        
        let height = cellHeight.height + topPadding + bottomPadding
        
        let frame = CGRect(x: 0, y: yOffset, width: UIScreen.main.bounds.width, height: height)
        let insetFrame = frame.insetBy(dx: topPadding, dy: bottomPadding)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        yOffset += height
      }
    }
  }
  
  override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]){
  
    
    log.info("prepare")
    cache.removeAll()
    guard let collectionView = self.collectionView else {return}

    
    var containerHeight: CGFloat = collectionView.frame.size.height
    containerHeight -= collectionView.contentInset.top
    containerHeight -= collectionView.contentInset.bottom
    let container = CGRect(x: collectionView.contentOffset.x,
                           y: collectionView.contentOffset.y,
                           width: collectionView.frame.size.width,
                           height: containerHeight)
    var yOffset: CGFloat = 0
    for section in 0 ..< collectionView.numberOfSections {
      let numberOfItems = collectionView.numberOfItems(inSection: section)
      for item in 0 ..< numberOfItems {
        let indexPath = IndexPath(item: item, section: section)
        
        let cellHeight = delegate.collectionView(collectionView, originalItemSizeAtIndexPath: indexPath)
        
        
        let height = cellHeight.height + topPadding + bottomPadding
        
        let frame = CGRect(x: 0, y: yOffset, width: UIScreen.main.bounds.width, height: height)
        let insetFrame = frame.insetBy(dx: topPadding, dy: bottomPadding)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        yOffset += height
      }
    }
    
    super.prepare(forCollectionViewUpdates: updateItems)
    
    
  }
  
  override func finalizeCollectionViewUpdates() {
    log.info("final")
  }
  
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return cache.filter{$0.frame.intersects(rect)}
  }
}
