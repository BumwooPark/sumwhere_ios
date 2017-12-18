//
//  MainViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 10..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class MainViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView()
//    collectionView.header = MainHeaderView()
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.title = "ZIP"
  }
}
