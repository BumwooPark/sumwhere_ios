//
//  ProfileHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import CHIPageControl

class PHeaderView: UIView {
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  let datas = BehaviorRelay<[String]>(value: [])
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: String(describing: ProfileHeaderCell.self))
    collectionView.isPagingEnabled = true
    collectionView.backgroundColor = .white
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()
  
  let pageControl: CHIPageControlAleppo = {
    let control = CHIPageControlAleppo()
    control.radius = 4
    control.currentPageTintColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    control.tintColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    control.padding = 6
    return control
  }()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<String>>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileHeaderCell.self), for: idx) as! ProfileHeaderCell
    cell.item = item
    return cell
  })
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(collectionView)
    addSubview(pageControl)
    bind()
    setNeedsUpdateConstraints()
  }
  
  private func bind(){
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    datas.map{[GenericSectionModel<String>(items: $0)]}
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    datas.map{$0.count}
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return { count in
          weakSelf.pageControl.numberOfPages = count
        }
      }.disposed(by: disposeBag)
    
    collectionView.rx.contentOffset
      .map{Int($0.x / UIScreen.main.bounds.width)}
      .distinctUntilChanged()
      .observeOn(MainScheduler.asyncInstance)
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {data in
          weakSelf.pageControl.set(progress: data, animated: true)
        }
      }.disposed(by: disposeBag)
    
    
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      collectionView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.height.equalTo(200)
      }
      
      pageControl.snp.makeConstraints { (make) in
        make.bottom.equalToSuperview().inset(13)
        make.centerX.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
  }
}

final class ProfileHeaderCell: UICollectionViewCell{
  var item: String?{
    didSet{
      guard let item = item else {return}
      profileImageView.kf.setImage(with: URL(string: item.addSumwhereImageURL()), options: [.transition(.fade(0.2))])
    }
  }
  private let profileImageView: UIImageView = {
    var imageView = UIImageView()
    imageView.kf.indicatorType = .activity
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
