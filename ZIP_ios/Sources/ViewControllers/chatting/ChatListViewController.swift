//
//  ChatListViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit


class ChatListViewController: ASViewController<ASDisplayNode>{
  
  lazy var tableNode: ASTableNode = {
    let node = ASTableNode()
    node.backgroundColor = .white
    node.dataSource = self
    node.delegate = self
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
  }
}

extension ChatListViewController: ASTableDataSource{
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }
  
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    return ChatListCellNode()
  }
}

extension ChatListViewController: ASTableDelegate{
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    self.navigationController?.pushViewController(ChatRoomViewController(), animated: true)
  }
}
