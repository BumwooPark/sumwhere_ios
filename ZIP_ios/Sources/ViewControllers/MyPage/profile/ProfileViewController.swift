//
//  ProfileViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 22/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import MXParallaxHeader
import RxSwift
import RxCocoa
import RxDataSources

class ProfileViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let viewModel = UserProfileViewModel()
  private let headerView = PHeaderView()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ProfileStyleCell.self, forCellWithReuseIdentifier: String(describing: ProfileStyleCell.self))
    collectionView.register(ProfileCharacterCell.self, forCellWithReuseIdentifier: String(describing: ProfileCharacterCell.self))
    collectionView.register(ProfileCollectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: ProfileCollectionHeaderView.self))
    collectionView.register(StyleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StyleHeaderView.self))
    collectionView.register(StyleCell.self, forCellWithReuseIdentifier: String(describing: StyleCell.self))
    collectionView.parallaxHeader.view = headerView
    collectionView.parallaxHeader.height = 222
    collectionView.parallaxHeader.minimumHeight = 0
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<ProfileSectionModel>(configureCell: {ds,cv,idx,item in
    switch ds[idx]{
    case .StyleSectionItem:
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileStyleCell.self), for: idx)
      return cell
    case .CharacterSectionItem:
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCharacterCell.self), for: idx)
      return cell
    case .DetailStyleSectionItem:
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: StyleCell.self), for: idx)
      return cell
    }
  },configureSupplementaryView: {ds,cv,title,idx in
    switch ds[idx]{
    case .StyleSectionItem:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: ProfileCollectionHeaderView.self), for: idx)
      return view
    case .CharacterSectionItem:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: ProfileCollectionHeaderView.self), for: idx)
      return view
    case .DetailStyleSectionItem:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StyleHeaderView.self), for: idx)
      return view
    }
  })
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    bind()
  }
  
  private func bind(){
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    viewModel.outputs
      .profileImageBinder
      .bind(to: headerView.datas)
      .disposed(by: disposeBag)
    
    viewModel.inputs.getUserProfile(userID: 8)
    
    viewModel.outputs.detailDatas
      .asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)

  }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section >= 2{
      return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }else{
      return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch dataSources[indexPath]{
    case .CharacterSectionItem:
      return CGSize(width: UIScreen.main.bounds.width, height: 50)
    case .StyleSectionItem:
      return .zero
    case .DetailStyleSectionItem:
      return CGSize(width: 90, height: 90)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section >= 2{
      return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }else {
      return .zero
    }
  }
}

