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


final class ProfileHeaderView: UIView {
  
  var didUpdateContraint = false
  private let disposeBag = DisposeBag()
  var profiles = [UIImage?](repeating: nil, count: 5)
  var viewController: SetProfileViewController?
  
  
  var currentIndex = 0
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(ProfileViewCell.self, forCellWithReuseIdentifier: String(describing: ProfileViewCell.self))
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(collectionView)
    
    reload()
    
    collectionView.rx
      .itemSelected
      .subscribe(onNext: {[weak self] index in
        guard let `self` = self else {return}
        let controller = TLPhotosPickerViewController()
        var configure = TLPhotosPickerConfigure()
        configure.allowedLivePhotos = true
        configure.autoPlay = true
        configure.maxSelectedAssets = 1
        controller.configure = configure
        controller.delegate = self
        self.viewController?.present(controller, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    setNeedsUpdateConstraints()
  }
  
  func reload(){
    Observable.just(profiles)
      .bind(to: collectionView.rx.items(
        cellIdentifier: String(describing: ProfileViewCell.self),
        cellType: ProfileViewCell.self)){
          idx, model, cell in
          cell.profileView.image = model
      }.disposed(by: disposeBag)
  }
  
  override func updateConstraints() {
    if !didUpdateContraint{
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      didUpdateContraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProfileHeaderView: TLPhotosPickerViewControllerDelegate{
  func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
  }
  
  func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
    profiles[currentIndex] = withTLPHAssets.first?.fullResolutionImage
    currentIndex += 1
    reload()
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

