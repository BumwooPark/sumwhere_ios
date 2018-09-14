//
//  ChatListViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit
import RxASDataSources
import RxSwift
import RxCocoa

class ChatListViewController: ASViewController<ASDisplayNode>{
  
  private let disposeBag = DisposeBag()
  private let viewModel = ChatListViewModel()
  
  let datas = BehaviorRelay<[ChatListSectionModel]>(value: [])
  
  let dataSources = RxASTableReloadDataSource<ChatListSectionModel>(configureCell:{ (ds, tn, idx, item) -> ASCellNode in
    let cell = ChatListCellNode()
    return cell
  })
  
  lazy var tableNode: ASTableNode = {
    let node = ASTableNode()
    node.backgroundColor = .white
    return node
  }()
  
  init() {
    super.init(node: ASDisplayNode())
    self.node.automaticallyManagesSubnodes = true
    self.node.layoutSpecBlock = {(_, constrainedSize) -> ASLayoutSpec in
      return ASInsetLayoutSpec(insets: .zero, child: self.tableNode)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    datas.asDriver()
      .drive(tableNode.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    viewModel.listData
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    tableNode.rx
      .modelSelected(ChatListModel.self)
      .subscribeNext(weak: self) { (weakSelf) -> (ChatListModel) -> Void in
        return { item in
          weakSelf.navigationController?.pushViewController(ChatRoomViewController(91, item.chatRoom.id), animated: true)
        }
    }.disposed(by: disposeBag)
  }
}
