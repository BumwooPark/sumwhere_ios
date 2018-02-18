//
//  ProfileHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import TLPhotoPicker

class ProfileHeaderView: UIView {
  
  let disposeBag = DisposeBag()
  weak var viewController: SetProfileViewController?
  private var currentIndex = 0
  var profiles = [UIImage?](repeating: nil, count: 5)
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(ProfileViewCell.self, forCellWithReuseIdentifier: String(describing: ProfileViewCell.self))
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  
  
    addSubview(collectionView)
    addConstraint()
  }
  
  private func addConstraint(){
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProfileHeaderView: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileViewCell.self), for: indexPath) as! ProfileViewCell
    cell.profileView.image = profiles[indexPath.item]
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    currentIndex = indexPath.item
    let controller = TLPhotosPickerViewController()
    var configure = TLPhotosPickerConfigure()
    configure.allowedLivePhotos = true
    configure.autoPlay = true
    configure.maxSelectedAssets = 1
    controller.configure = configure
    controller.delegate = self

    viewController?.present(controller, animated: true, completion: nil)
    
  }
}

extension ProfileHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, TLPhotosPickerViewControllerDelegate{
  func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
  }
  
  func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
    profiles[currentIndex] = withTLPHAssets.first?.fullResolutionImage
    collectionView.reloadData()
  }
}

class ProfileViewCell: UICollectionViewCell{
  let profileView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 5
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = .lightGray
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(profileView)
    profileView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

