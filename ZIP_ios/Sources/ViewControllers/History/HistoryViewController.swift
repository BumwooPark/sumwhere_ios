//
//  ReceiveHistoryViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 01/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController{
  
  let viewModel: MatchHistoryTypes
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(HistoryHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: HistoryHeaderView.self))
    collectionView.register(HistoryCell.self,
                            forCellWithReuseIdentifier: String(describing: HistoryCell.self))
    collectionView.register(HistoryFooterView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: String(describing: HistoryFooterView.self))
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  init(viewModel: MatchHistoryTypes) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.backgroundView = HistoryReceiveEmptyView(frame: collectionView.bounds)
  }
}
