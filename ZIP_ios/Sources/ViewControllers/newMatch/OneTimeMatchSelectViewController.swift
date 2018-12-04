//
//  OneTimeMatchSelectViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 04/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

class OneTimeMatchSelectViewController: UIViewController {
  let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  let collectionView: UICollectionView = {
    let layout = CardCollectionViewLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 306, height: 380)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(OneTimeMatchSelectCell.self, forCellWithReuseIdentifier: String(describing: OneTimeMatchSelectCell.self))
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    Observable.just([UIColor.red,UIColor.blue,UIColor.green,UIColor.gray,UIColor.black])
      .bind(to: collectionView.rx.items(cellIdentifier: String(describing: OneTimeMatchSelectCell.self), cellType: OneTimeMatchSelectCell.self)){ index, model, cell in
        cell.contentView.backgroundColor = model
      }.disposed(by: disposeBag)
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
