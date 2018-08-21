//
//  DetailUserInfoViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import SnapKit

class DetailUserInfoViewController: UIViewController{
  
  let model: UserTripJoinModel
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UINib(nibName: "DetailUserImageCell", bundle: nil), forCellWithReuseIdentifier: String(describing: DetailUserImageCell.self))
    collectionView.register(UINib(nibName: "DetailUserProfileInfoCell", bundle: nil), forCellWithReuseIdentifier: String(describing: DetailUserProfileInfoCell.self))
    collectionView.register(UINib(nibName: "DetailUserIntroduceCell", bundle: nil), forCellWithReuseIdentifier: String(describing: DetailUserIntroduceCell.self))
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  init(model: UserTripJoinModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
  }
}

extension DetailUserInfoViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    switch indexPath.item{
    case 0:
      return CGSize(width: collectionView.frame.width - 20, height: 300)
    case 1,2:
      return CGSize(width: collectionView.frame.width - 20, height: 300)
    default:
      return .zero
    }
  }
}

extension DetailUserInfoViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell: BaseDetailInfoCell
    switch indexPath.item{
    case 0:
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailUserImageCell.self),
                             for: indexPath) as! BaseDetailInfoCell
    case 1:
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailUserProfileInfoCell.self),
                             for: indexPath) as! BaseDetailInfoCell
    case 2:
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailUserIntroduceCell.self),
                             for: indexPath) as! BaseDetailInfoCell
    default:
      return UICollectionViewCell()
    }
    
    cell.layer.cornerRadius = 10
    cell.layer.shadowColor = UIColor.lightGray.cgColor
    cell.layer.shadowOffset = CGSize(width: 2, height: 2)
    cell.layer.shadowOpacity = 10
    cell.item = model
    return cell
  }
}

extension DetailUserInfoViewController: UICollectionViewDelegate{}
