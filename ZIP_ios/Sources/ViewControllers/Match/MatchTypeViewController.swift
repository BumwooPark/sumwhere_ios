//
//  MatchTypeViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

struct SampleModel{
  let image: UIImage
  let title: String
  let subTitle: String
  var isSelected: Bool
}

final class MatchTypeViewController: UIViewController{
  let disposeBag = DisposeBag()
  var items: [SampleModel] = [SampleModel(image: #imageLiteral(resourceName: "onetimematchImage.png"),title: "즉흥 매칭", subTitle: "새로운 인연과 함께하는 여행", isSelected: true),
                              SampleModel(image: #imageLiteral(resourceName: "planmatchImage.png"),title: "계획 매칭", subTitle: "같은 시간, 같은 공간 우리 동행하자", isSelected: false),
                              SampleModel(image: #imageLiteral(resourceName: "onetimematchImage.png"),title: "", subTitle: String() ,isSelected: false),
                              SampleModel(image: #imageLiteral(resourceName: "planmatchImage.png"),title: "", subTitle: String() ,isSelected: false)]
  
  let submitAction = PublishRelay<Int>()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MatchTypeCell.self, forCellWithReuseIdentifier: String(describing: MatchTypeCell.self))
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.allowsSelection = true
    collectionView.allowsMultipleSelection = false
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    
    self.navigationController?.navigationBar.topItem?.title = String()
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
    submitAction.subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
      return {idx in
        weakSelf.navigationController?.pushViewController(MatchSelectGenderViewController(), animated: true)
        log.info(idx)
      }
    }.disposed(by: disposeBag)
  }
}

extension MatchTypeViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: MatchTypeCell.self),
      for: indexPath) as! MatchTypeCell
    cell.item = items[indexPath.item]
    cell.tag = indexPath.item
    cell.submitAction = submitAction
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
}

extension MatchTypeViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if items[indexPath.item].isSelected{
      return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height/5)*2)
    }else{
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/5)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    for (i,_) in items.enumerated(){
      items[i].isSelected = false
    }
    items[indexPath.item].isSelected = true
    
    collectionView.reloadData()
//    collectionView.collectionViewLayout.invalidateLayout()
//    let cell = collectionView.cellForItem(at: indexPath) as! MatchTypeCell
//    UIView.transition(with: collectionView, duration: 0.1, options: .curveEaseOut, animations: {
////      cell.frame.size = CGSize(width: collectionView.frame.width, height: (collectionView.frame.height/5)*2)
////      collectionView.collectionViewLayout.invalidateLayout()
//    }, completion: nil)
  }
}
