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
import RxGesture

class ProfileViewController: UIViewController{
  var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  private let viewModel = UserProfileViewModel()
  private let headerView = PHeaderView()
  private let buttonView = ProfileSubmitButtonView()
  let userID: Int
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ProfileStyleCell.self, forCellWithReuseIdentifier: String(describing: ProfileStyleCell.self))
    collectionView.register(ProfileCharacterCell.self, forCellWithReuseIdentifier: String(describing: ProfileCharacterCell.self))
    collectionView.register(ProfileCollectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: ProfileCollectionHeaderView.self))
    collectionView.register(ProfileStyleCollectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: ProfileStyleCollectionHeaderView.self))
    collectionView.register(StyleHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: StyleHeaderView.self))
    collectionView.register(StyleCell.self, forCellWithReuseIdentifier: String(describing: StyleCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.parallaxHeader.view = headerView
    collectionView.parallaxHeader.height = 222
    collectionView.parallaxHeader.minimumHeight = 0
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<ProfileSectionModel>(configureCell: {ds,cv,idx,item in
    switch ds[idx]{
    case .StyleSectionItem:
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileStyleCell.self), for: idx)
      return cell
    case .CharacterSectionItem(let item):
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCharacterCell.self), for: idx) as! ProfileCharacterCell
      cell.item = item.profile.characterType
      return cell
    case .DetailStyleSectionItem(let style):
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: StyleCell.self), for: idx) as! StyleCell
      cell.item = style
      return cell
    }
  },configureSupplementaryView: {ds,cv,title,idx in
    switch ds[idx]{
    case .StyleSectionItem:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                     withReuseIdentifier: String(describing: ProfileStyleCollectionHeaderView.self),
                                                     for: idx) as! ProfileStyleCollectionHeaderView
      view.nickname = ds[idx.section].name
      return view
    case .CharacterSectionItem:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                     withReuseIdentifier: String(describing: ProfileCollectionHeaderView.self),
                                                     for: idx) as!  ProfileCollectionHeaderView
      view.nickname = ds[idx.section].name
      return view
    case .DetailStyleSectionItem:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                     withReuseIdentifier: String(describing: StyleHeaderView.self),
                                                     for: idx) as! StyleHeaderView
      view.item = ds[idx.section].iconTitle
      return view
    }
  })
  
  init(id: Int){
    userID = id
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    view.addSubview(buttonView)
    bind()
    view.setNeedsUpdateConstraints()
  }
  
  private func bind(){
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx.swipeGesture(.down)
      .subscribeNext(weak: self) { (weakSelf) -> (UISwipeGestureRecognizer) -> Void in
        return {gesture in
          log.info(gesture)
          log.info(weakSelf.collectionView.contentOffset)
        }
    }.disposed(by: disposeBag)
    
    viewModel.outputs
      .profileImageBinder
      .bind(to: headerView.datas)
      .disposed(by: disposeBag)
    
    viewModel.inputs.getUserProfile(userID: userID)
    
    viewModel.outputs.detailDatas
      .asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      buttonView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(70)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
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
      return CGSize(width: UIScreen.main.bounds.width - 150, height: 80)
    case .StyleSectionItem:
      return CGSize(width: 0.1, height: 0.1)
    case .DetailStyleSectionItem:
      return CGSize(width: 90, height: 90)
    }
  }
}

