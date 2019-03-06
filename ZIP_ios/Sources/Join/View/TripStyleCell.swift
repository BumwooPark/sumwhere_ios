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
  
  var item: SelectTripStyleModel?{
    didSet{
      guard let item = item else {return}
      datas.accept([TripStyleDetailViewModel(items: item.selectedData)])
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
    layout.itemSize = CGSize(width: 37, height: 50)
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
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 42))
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
  typealias Item = SelectTripStyleModel.TripType
  
  init(original: TripStyleDetailViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

class TripStyleDetailCell: UICollectionViewCell{

  var item: SelectTripStyleModel.TripType?{
    didSet{
      guard case let .type(name,select,_)? = item else {return}
      iconImageView.image = select
      titleLabel.text = "<" + name + ">"
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
    label.font = .AppleSDGothicNeoMedium(size: 9)
    label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(iconImageView)
    contentView.addSubview(titleLabel)
    
    iconImageView.snp.makeConstraints { (make) in
      make.left.right.top.equalToSuperview()
      make.height.equalTo(self.snp.width)
    }
  
    titleLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(iconImageView.snp.bottom).offset(5)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
