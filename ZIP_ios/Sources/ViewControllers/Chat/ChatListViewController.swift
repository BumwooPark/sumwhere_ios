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
import MGSwipeTableCell
import MessageKit

class ChatListViewController: UIViewController, UICollectionViewDelegateFlowLayout{
  
  private let disposeBag = DisposeBag()
  private let datas = BehaviorRelay<[ChatListSectionViewModel]>(value: [])
  private let dataSources = RxTableViewSectionedReloadDataSource<ChatListSectionViewModel>(configureCell: {ds,tv,idx,item in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: ChatListCell.self), for: idx) as! ChatListCell
    let swipeButton = MGSwipeButton(title: "나가기", backgroundColor: .red)
    cell.rightButtons = [swipeButton]
    cell.item = item
    return cell
  })
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 95
    tableView.backgroundColor = .white
    tableView.register(ChatListCell.self, forCellReuseIdentifier: String(describing: ChatListCell.self))
    tableView.separatorStyle = .none
    return tableView
  }()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    view = tableView
    title = "채팅"

    
    
    collectionViewEmptyView()
    Conversation.showConversations {[weak self] (models) in
      self?.datas.accept([ChatListSectionViewModel(items: models)])
      self?.tableView.backgroundView = nil
    }
    
    datas.asDriver()
      .drive(tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    
    tableView.rx.modelSelected(Conversation.self)
      .subscribeNext(weak: self) { (weakSelf) -> (Conversation) -> Void in
        return { model in
          weakSelf.navigationController?.pushViewController(ChatRoomViewController(conversation: model), animated: true)
        }
      }.disposed(by: disposeBag)

  }
  
  private func collectionViewEmptyView(){
    tableView.backgroundView = EmptyChatView(frame: CGRect(origin: .zero, size: tableView.bounds.size))
  }
}

//extension ChatListViewController: SkeletonTableViewDataSource{
//  func numSections(in collectionSkeletonView: UITableView) -> Int {
//    return 1
//  }
//
//  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 1
//  }
//
//  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//
//  }
//}
