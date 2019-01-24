//
//  MatchTypeViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa


enum MatchType{
  case onetime(MatchTypeModel)
  case schedule(MatchTypeModel)
}

struct MatchTypeModel{
  let image: UIImage
  let title: String
  let subTitle: String
  var isSelected: Bool
}

final class MatchTypeViewController: UIViewController{
  let disposeBag = DisposeBag()
  var items: [MatchType] = [MatchType.onetime(MatchTypeModel(image: #imageLiteral(resourceName: "onetimematchImage.png"),title: "즉흥 매칭", subTitle: "새로운 인연과 함께하는 여행", isSelected: true)),MatchType.schedule(MatchTypeModel(image: #imageLiteral(resourceName: "planmatchImage.png"),title: "계획 매칭", subTitle: "같은 시간, 같은 공간 우리 동행하자", isSelected: false))]
  
  let submitAction = PublishRelay<Int>()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 150)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MatchTypeCell.self, forCellWithReuseIdentifier: String(describing: MatchTypeCell.self))
    collectionView.backgroundColor = .white
    collectionView.allowsSelection = true
    collectionView.allowsMultipleSelection = false
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    
    self.navigationController?.navigationBar.topItem?.title = String()
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    Observable.just(items)
      .bind(to: collectionView.rx.items(cellIdentifier: String(describing: MatchTypeCell.self), cellType: MatchTypeCell.self)){
        idx, item, cell in
        switch item{
        case .onetime(let model),.schedule(let model):
          cell.item = model
        }
      
    }.disposed(by: disposeBag)
    
    collectionView.rx
      .itemSelected
      .subscribeNext(weak: self) {(weakSelf) -> (IndexPath) -> Void in
        return { idx in
          switch weakSelf.items[idx.item]{
          case .onetime:
            weakSelf.present(CreateTripViewController(), animated: true, completion: nil)
          case .schedule:
            weakSelf.present(CreateTripViewController(), animated: true, completion: nil)
          }
          
        }
    }.disposed(by: disposeBag)
  }
}


