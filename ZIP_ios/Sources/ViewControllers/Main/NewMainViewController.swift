//
//  NewMainViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import MXParallaxHeader

class NewMainViewController: UIViewController {
  private let keyStoreButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "mainkeystoreicon.png") , for: .normal)
    return button
  }()
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.parallaxHeader.view = MainHeaderView()
    collectionView.parallaxHeader.minimumHeight = 0
    collectionView.parallaxHeader.height = 461
    collectionView.parallaxHeader.mode = .fill
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: keyStoreButton)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "taskbarMacthingNot.png").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
  }
}
