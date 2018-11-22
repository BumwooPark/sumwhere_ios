//
//  PlanFlowLayout.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

protocol PlanFlowLayoutDelegate: class {
   func collectionView (_ collectionView : UICollectionView
    , heightForPhotoAtIndexPath indexPath : IndexPath) -> CGFloat
}

class PlanFlowLayout: UICollectionViewFlowLayout{
  var delegate: PlanFlowLayoutDelegate!
  
  private var numberOfColumns = 2
  private var cellPadding: CGFloat = 6
  private var cache = [UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
//    캐시가 비어있거나 컬렉션뷰가 있을때에만 실행
    
    guard cache.isEmpty == true, let collectionView = collectionView, collectionView.numberOfSections != 0 else {
      return
    }
    
//    컬럼의 넓이는 컨텐스 사이즈 넓이에 2를 나눈값
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    for column in 0 ..< numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

      let indexPath = IndexPath(item: item, section: 0)


//       4. 델리게이트로부터 height를 받아서 frame 크기를 계산한다
      let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      // 5. 컬랙션뷰레이아웃 아이탬을 만들고 frame생성후 캐시에 추가한다
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)

      // 6. 컬랙션뷰의 컨탠츠 높이를 변경한다
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height

      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}

