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
import Kingfisher


struct ImageModel {
  var images: [UIImage?]
  var imageURL: [String]
  init() {
    self.images = [UIImage?](repeating: nil, count: 5)
    self.imageURL = [String](repeating: String(), count: 5)
  }
}

class ProfileHeaderView: UIView {
  
  let disposeBag = DisposeBag()
  weak var viewController: SetProfileViewController?{
    didSet{
      let item = viewController?.item
      guard let image1 = item?.image1, let image2 = item?.image2,
        let image3 = item?.image3, let image4 = item?.image4, let image5 = item?.image5 else {return}
      self.images.imageURL = [image1,image2,image3,image4,image5]
      collectionView.reloadData()
    }
  }
  
  private var currentIndex = 0
  
  var profiles = [UIImage?](repeating: nil, count: 5)
  var images = ImageModel()
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
    return images.images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileViewCell.self), for: indexPath) as! ProfileViewCell
    
    if images.imageURL[indexPath.item] == String(){
      cell.profileView.image = images.images[indexPath.item]
    }else{
      cell.profileView.kf.setImageWithZIP(image: images.imageURL[indexPath.item])
    }
    
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
    images.images[currentIndex] = withTLPHAssets.first?.fullResolutionImage
    viewController?.images[currentIndex] = withTLPHAssets.first?.fullResolutionImage
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

