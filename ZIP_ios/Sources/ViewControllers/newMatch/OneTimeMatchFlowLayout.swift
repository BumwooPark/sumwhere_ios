//
//  OneTimeMatchFlowLayout.swift
//  ZIP_ios
//
//  Created by xiilab on 04/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

internal class CardCollectionViewLayout: UICollectionViewFlowLayout {
  internal var isPagingEnabled: Bool = true
  
  public var spacing: CGFloat = 30.0 {
    didSet{
      if collectionView != nil {
        invalidateLayout()
      }
    }
  }
  
  public var maximumVisibleItems: Int = 5 {
    didSet{
      if collectionView != nil {
        invalidateLayout()
      }
    }
  }
}

// MARK: - compute layout
extension CardCollectionViewLayout{
  func computeLayoutAttributesForItem(indexPath: IndexPath,
                                      minVisibleIndex: Int,
                                      contentCenterY: CGFloat,
                                      deltaOffset: CGFloat,
                                      percentageDeltaOffset: CGFloat) -> UICollectionViewLayoutAttributes {
    if collectionView == nil {
      return UICollectionViewLayoutAttributes(forCellWith: indexPath)
    }
    
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    let cardIndex = indexPath.row - minVisibleIndex
    attributes.size = itemSize
    attributes.center = CGPoint(x: collectionView!.bounds.midX , y: contentCenterY + spacing * CGFloat(cardIndex))
//    + spacing * CGFloat(cardIndex)
    attributes.zIndex = maximumVisibleItems - cardIndex
    
    switch cardIndex{
    case 0:
      attributes.center.y -= deltaOffset
      log.info(attributes.center.y)
    case 1..<maximumVisibleItems:
//      attributes.center.x -= spacing * percentageDeltaOffset
      attributes.center.y -= spacing * percentageDeltaOffset
      if cardIndex == maximumVisibleItems - 1{
        attributes.alpha = percentageDeltaOffset
        attributes.transform = CGAffineTransform(scaleX: percentageDeltaOffset, y: percentageDeltaOffset)
      }
      log.info(percentageDeltaOffset)
      
    default:
      break
    }
    return attributes
  }
}


// MARK: UICollectionViewLayout
extension CardCollectionViewLayout {
  override open func prepare(){
    super.prepare()
    assert(collectionView?.numberOfSections == 1,"Multiple sections aren't supported!")
  }
  
  override var collectionViewContentSize: CGSize{
    if collectionView == nil {return CGSize.zero}
    
    let itemsCount = CGFloat(collectionView!.numberOfItems(inSection: 0))
    return CGSize(width: collectionView!.bounds.width , height: collectionView!.bounds.height * itemsCount)
//    * itemsCount
  }
  
  
  override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    if collectionView == nil { return nil }
    let totalItemsCount = collectionView!.numberOfItems(inSection: 0)
    let minVisibleIndex = max(0, Int(collectionView!.contentOffset.y)/Int(collectionView!.bounds.height))
    let maxVisibleIndex = min(totalItemsCount, minVisibleIndex + maximumVisibleItems)
    
    let contentCenterY = collectionView!.contentOffset.y + collectionView!.bounds.height / 2
    let deltaOffset = Int(collectionView!.contentOffset.y) % Int(collectionView!.bounds.height)
    let percentageDeltaOffset = CGFloat(deltaOffset) / collectionView!.bounds.height
    
    var attributes = [UICollectionViewLayoutAttributes]()
    for i in minVisibleIndex ..< maxVisibleIndex {
      let attribute = computeLayoutAttributesForItem(indexPath: IndexPath(item: i, section: 0),
                                                     minVisibleIndex: minVisibleIndex,
                                                     contentCenterY: contentCenterY,
                                                     deltaOffset: CGFloat(deltaOffset),
                                                     percentageDeltaOffset: percentageDeltaOffset)
      attributes.append(attribute)
    }
    return attributes
  }
  
  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}


extension CardCollectionViewLayout{
 
}
