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

class ChatListViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let viewModel = ChatListViewModel()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<ChatListSectionModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ChatListCell.self), for: idx) as! ChatListCell
    cell.item = item
    return cell
  })
  
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

    
    viewModel.datas
      .asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    viewModel.datas
      .map{$0.count}
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return { value in
          if value == 0 {
            weakSelf.collectionViewEmptyView()
          }else {
            weakSelf.collectionView.backgroundView = nil
          }
        }
      }.disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(ChatListModel.self)
      .subscribeNext(weak: self) { (weakSelf) -> (ChatListModel) -> Void in
        return {model in
          log.info(model)
          weakSelf.navigationController?.pushViewController(ChatRoomViewController(roomID: model.chatRoom.id, userID: model.chatMember.userId), animated: true)
        }
      }.disposed(by: disposeBag)
  }
  
  private func collectionViewEmptyView(){
    collectionView.backgroundView = EmptyChatView(frame: CGRect(origin: .zero, size: collectionView.bounds.size))
  }
}
