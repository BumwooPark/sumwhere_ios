//
//  OneTimeMatchViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 16/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import MXParallaxHeader

class OneTimeMatchViewController: UIViewController{
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  let sampleView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    collectionView.parallaxHeader.view = sampleView
    collectionView.parallaxHeader.height = UIScreen.main.bounds.height
    collectionView.parallaxHeader.mode = MXParallaxHeaderMode.fill
  }
}
