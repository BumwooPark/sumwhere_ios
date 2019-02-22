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
    layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ProfileCharacterCell.self, forCellWithReuseIdentifier: String(describing: ProfileCharacterCell.self))
    collectionView.register(ProfileStyleCell.self, forCellWithReuseIdentifier: String(describing: ProfileStyleCell.self))
    collectionView.parallaxHeader.view = headerView
    collectionView.parallaxHeader.height = 222
    collectionView.parallaxHeader.minimumHeight = 0
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<ProfileSectionModel>(configureCell: {ds,cv,idx,item in
    switch ds[idx]{
    case .CharacterSectionItem:
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileStyleCell.self), for: idx)
      return cell
    case .StyleSectionItem(let enabled):
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCharacterCell.self), for: idx)
      return cell
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
    
    
  }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .zero
  }
}

