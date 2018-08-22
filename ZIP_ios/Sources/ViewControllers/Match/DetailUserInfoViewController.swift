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
    layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UINib(nibName: "DetailUserImageCell", bundle: nil), forCellWithReuseIdentifier: String(describing: DetailUserImageCell.self))
    collectionView.register(UINib(nibName: "DetailUserProfileInfoCell", bundle: nil), forCellWithReuseIdentifier: String(describing: DetailUserProfileInfoCell.self))
    collectionView.register(DetailGradeCell.self, forCellWithReuseIdentifier: String(describing: DetailGradeCell.self))
    collectionView.register(UINib(nibName: "DetailTripStyleCell", bundle: nil), forCellWithReuseIdentifier: String(describing: DetailTripStyleCell.self))
    collectionView.register(DetailCharacterCell.self, forCellWithReuseIdentifier: String(describing: DetailCharacterCell.self))
    collectionView.register(DetailInterestCell.self, forCellWithReuseIdentifier: String(describing: DetailInterestCell.self))
    collectionView.register(DetailCommitView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: DetailCommitView.self))
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


//MARK: - Cell Size Delegate
extension DetailUserInfoViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    switch indexPath.item{
    case 0:
      return CGSize(width: collectionView.frame.width - 20, height: 400)
    case 1:
      return CGSize(width: collectionView.frame.width - 20, height: 150)
    case 2:
      return CGSize(width: collectionView.frame.width - 20, height: 170)
    case 3:
      return CGSize(width: collectionView.frame.width - 20, height: 200)
    case 4:
      return CGSize(width: collectionView.frame.width - 20, height: 150)
    case 5:
      return CGSize(width: collectionView.frame.width - 20, height: 300)
    default:
      return .zero
    }
  }
}

extension DetailUserInfoViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 6
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell: UICollectionViewCell & MatchDataSavable
    switch indexPath.item{
    case 0:
      //프로필 이미지
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailUserImageCell.self),
                             for: indexPath) as! UICollectionViewCell & MatchDataSavable
    case 1:
      // 나이 직업 지역
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailUserProfileInfoCell.self),
                             for: indexPath) as! UICollectionViewCell & MatchDataSavable
    case 2:
      // 평점
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailGradeCell.self),
        for: indexPath) as! UICollectionViewCell & MatchDataSavable
    case 3:
      //여행 스타일
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailTripStyleCell.self),
                             for: indexPath) as! UICollectionViewCell & MatchDataSavable
    case 4:
      //성격
      cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: String(describing: DetailCharacterCell.self),
                             for: indexPath) as! UICollectionViewCell & MatchDataSavable
    case 5:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailInterestCell.self), for: indexPath) as! UICollectionViewCell & MatchDataSavable
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
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: DetailCommitView.self), for: indexPath)
  }
  
}

extension DetailUserInfoViewController: UICollectionViewDelegate{}
