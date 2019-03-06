//
//  RegisterdSubviewController.swift
//  ZIP_ios
//
//  Created by xiilab on 29/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//


import RxDataSources
import RxCocoa
import RxSwift

enum TripSelectorType{
  case gender(icon: UIImage, title: String)
  case date(icon: UIImage, start: String, end: String)
  case comment(icon: UIImage, title: String)
}

class RegisterdSubviewController: UIViewController, UICollectionViewDelegateFlowLayout{
  private let disposeBag = DisposeBag()
  
  let data = PublishRelay<TripModel>()
  lazy var selectAction = collectionView.rx.modelSelected(TripSelectorType.self).share()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<TripSelectorType>>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(
      withReuseIdentifier: String(describing: ResisterdSubviewCell.self), for: idx) as! ResisterdSubviewCell
    cell.item = item
    return cell
  })
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = CGSize(width: 100, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ResisterdSubviewCell.self, forCellWithReuseIdentifier: String(describing: ResisterdSubviewCell.self))
    collectionView.backgroundColor = .white
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    collectionView.alwaysBounceHorizontal = true
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()
  
  override func loadView() {
    super.loadView()
    view = collectionView
    
    data.flatMapLatest { (model) in
      return Observable<[TripSelectorType]>
        .just([.date(icon: #imageLiteral(resourceName: "currentTimeIcon.png"), start: model.trip.startDate,end: model.trip.endDate),
               .comment(icon: #imageLiteral(resourceName: "currentTimeIcon.png"), title: model.trip.activity)])
      }.map{[GenericSectionModel<TripSelectorType>(items: $0)]}
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
  }
}

class ResisterdSubviewCell: UICollectionViewCell{
  
  var item: TripSelectorType?{
    didSet{
      guard let item = item else {return}
      switch item {
      case .date(let icon, let start, let end):
        cellButton.setImage(icon, for: .normal)
        if let startAt = start.toDate()?.toFormat("M월dd일"), let endAt = end.toDate()?.toFormat("dd일"){
          cellButton.setTitle("\(startAt) - \(endAt)", for: .normal)
        }
      case .comment(let icon, let title):
        cellButton.setImage(icon, for: .normal)
        cellButton.setTitle(title, for: .normal)
      case .gender(let icon, let title):
        cellButton.setImage(icon, for: .normal)
        if title == "NONE"{
          cellButton.setTitle("상관없음", for: .normal)
        }else if title == "MALE"{
          cellButton.setTitle("남자", for: .normal)
        }else{
          cellButton.setTitle("여자", for: .normal)
        }
      }
    }
  }
  private let cellButton: UIButton = {
    let button = UIButton()
    button.isEnabled = false
    button.setImage(#imageLiteral(resourceName: "currentTimeIcon.png"), for: .normal)
    button.titleLabel?.font = UIFont.AppleSDGothicNeoSemiBold(size: 11.2)
    button.setTitleColor(#colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(cellButton)
    contentView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    contentView.layer.masksToBounds = true
    
    cellButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20))
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.cornerRadius = contentView.frame.height/2
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
