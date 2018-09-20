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
          let mqtt = MQTTUtil.newBuild(with: "client")
            .keepAlive(time: 60)
            .newAccount(username: "qkrqjadn", password: "1q2w3e4r")
            .newURL(host: "210.100.238.118", port: 18883)
            .build()
          mqtt.connect()
          weakSelf.navigationController?.pushViewController(ChatRoomViewController(mqtt,91, item.chatRoom.id), animated: true)
        }
    }.disposed(by: disposeBag)
  }
}
