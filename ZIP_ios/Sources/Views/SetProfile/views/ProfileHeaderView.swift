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
import RxGesture
import TLPhotoPicker
import Kingfisher


final class ProfileHeaderView: UIView {
  
  var didUpdateContraint = false
  private let disposeBag = DisposeBag()
  var profiles = [UIImage?](repeating: nil, count: 5){
    didSet{
      viewController?.viewModel
        .modelSaver
        .onNext(.image(value: profiles))
    }
  }
  var viewController: SetProfileViewController?
  
  let datas = BehaviorRelay<[SectionOfCustomData]>(value: [])
  
  var currentIndex = 0
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: {[unowned self] ds,cv,idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileViewCell.self), for: idx) as! ProfileViewCell
    cell.item = item
    cell.vc = self
    cell.tag = idx.item
    cell
      .profileImageAction
      .map{_ in return ()}
      .do(onNext:{self.currentIndex = idx.item})
      .bind(onNext: self.pushImageSelectView)
      .disposed(by: self.disposeBag)
    
    return cell
  })
  
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
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    setNeedsUpdateConstraints()
  }
  
  
  func reload(){
    imageSort()
    Observable.just([SectionOfCustomData(items: profiles)])
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  func pushImageSelectView(){
    let controller = TLPhotosPickerViewController()
    var configure = TLPhotosPickerConfigure()
    configure.allowedLivePhotos = true
    configure.autoPlay = true
    configure.maxSelectedAssets = 1
    controller.configure = configure
    controller.delegate = self
    self.viewController?.present(controller, animated: true, completion: nil)
  }
  
  func imageSort(){
    profiles.sort { (one, two) -> Bool in
      if one != nil {
        if two == nil {
          return true
        }else{
          return false
        }
      }else{
        if two != nil {
          return false
        }else{
          return true
        }
      }
    }
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
    reload()
  }
}

class ProfileViewCell: UICollectionViewCell{
  var vc: ProfileHeaderView?
  let disposeBag = DisposeBag()
  
  var item: UIImage?{
    didSet{
      if let image = item{
        profileView.image = image
        cancelButton.isEnabled = true
        cancelButton.isHidden = false
      }else{
        profileView.image = #imageLiteral(resourceName: "icons8-plus_math_filled").withRenderingMode(.alwaysTemplate)
        cancelButton.isEnabled = false
        cancelButton.isHidden = true
      }
    }
  }
  
  let cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "deleteAll"), for: .normal)
    button.isEnabled = false
    button.isHidden = true
    return button
  }()
  
  let profileView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 5
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 0.3
    imageView.tintColor = #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  lazy var profileImageAction = profileView.rx.tapGesture()
    .when(.ended)
    .share()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(profileView)
    profileView.addSubview(cancelButton)
    
    cancelButton.rx.tap
      .subscribe(onNext: {[unowned self] in
        self.vc?.profiles[self.tag] = nil
        self.vc?.reload()
      }).disposed(by: disposeBag)
    
    profileView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    cancelButton.snp.makeConstraints { (make) in
      make.right.equalTo(profileView.snp.right)
      make.top.equalTo(profileView.snp.top)
      make.height.width.equalTo(20)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

