//
//  ReceiveViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import DZNEmptyDataSet

final class ReceiveViewController: UIViewController{
  
  var didUpdateConstraint = false
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.emptyDataSetSource = self
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension ReceiveViewController: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "받은 요청이 없습니다.", attributes: [NSAttributedStringKey.font:UIFont.NotoSansKRBold(size: 30)])
  }
}
