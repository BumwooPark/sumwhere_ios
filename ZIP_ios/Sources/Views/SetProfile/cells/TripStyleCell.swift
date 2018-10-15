//
//  TripStyleCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 24..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class TripStyleCell: UITableViewCell{
  
  var disposeBag = DisposeBag()
  
  var item: [TripStyleModel.Element]?{
    didSet{
      guard let item = item else {return}
      Observable.just(item)
        .map{[TripStyleDetailViewModel(items: $0)]}
        .bind(to: datas)
        .disposed(by: disposeBag)
    }
  }
  
  var didUpdateConstraint = false
  
  let datas = BehaviorRelay<[TripStyleDetailViewModel]>(value: [])
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<TripStyleDetailViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TripStyleDetailCell.self), for: idx) as! TripStyleDetailCell
    cell.item = item
    return cell
  })
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 76, height: 67)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(TripStyleDetailCell.self, forCellWithReuseIdentifier: String(describing: TripStyleDetailCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceHorizontal = true
    collectionView.allowsMultipleSelection = true
    return collectionView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    
    contentView.addSubview(collectionView)
    setNeedsUpdateConstraints()
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct TripStyleDetailViewModel {
  var items: [Item]
}

extension TripStyleDetailViewModel: SectionModelType{
  typealias Item = TripStyleModel.Element
  
  init(original: TripStyleDetailViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

class TripStyleDetailCell: UICollectionViewCell{
  
  override var isSelected: Bool{
    didSet{
      contentView.layer.borderColor = isSelected ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
      titleLabel.textColor = isSelected ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
      iconImageView.tintColor = isSelected ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
    }
  }
  
  var item: TripStyleModel.Element?{
    didSet{
      titleLabel.text = item?.name
//      iconImageView.kf.setImageWithZIP(image: item?.iconURL ?? String())
      
      KingfisherManager.shared.retrieveImage(with: URL(string: AuthManager.imageURL + (item?.iconURL ?? String()))!, options: nil, progressBlock: nil) {[weak self] (image, error, type, url) in
        self?.iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
      }
    }
  }
  
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 12)
    label.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.layer.borderWidth = 1.5
    contentView.layer.cornerRadius = 6
    contentView.layer.borderColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1).cgColor
    
    contentView.addSubview(iconImageView)
    contentView.addSubview(titleLabel)
    
    iconImageView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(15)
      make.height.width.equalTo(25)
    }
  
    titleLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(5)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
