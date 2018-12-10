//
//  ChatListViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


import RxSwift
import RxCocoa
import RxDataSources
import CocoaMQTT

class ChatListViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let viewModel = ChatListViewModel()
  
//  let datas = BehaviorRelay<[ChatListSectionModel]>(value: [])
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 95)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ChatListCell.self, forCellWithReuseIdentifier: String(describing: ChatListCell.self))
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    Observable.just([1,2,3,4,5]).bind(to: collectionView.rx.items(cellIdentifier: String(describing: ChatListCell.self), cellType: ChatListCell.self)){ ds,idx,cell in
    }.disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribeNext(weak: self) { (weakSelf) -> (IndexPath) -> Void in
        return {idx in
          let mqtt = MQTTUtil
            .newBuild(with: "data")
            .keepAlive(time: 20)
            .newAccount(username: "qkrqjadn", password: "1q2w3e4r")
            .newURL(host: "http://sample.com", port: 8080)
            .build()
          weakSelf.navigationController?.pushViewController(ChatRoomViewController(mqtt, 86, 1), animated: true)
        }
      }.disposed(by: disposeBag)
  }
}
