//
//  ChatRoomViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit
import RxSwift

class ChatRoomViewController: ChatNodeViewController{
  private let disposeBag = DisposeBag()
  
  let viewModel: MQViewModel = {
    let viewModel = MQViewModel(host: "192.168.1.19", subscribeTopic: "go-mqtt/sample")
    return viewModel
  }()
  
  lazy var messageInputNode: InputBoxNode = {
    let node = InputBoxNode()
    node.setMessageBoxHeight()
    return node
  }()
  
   var items: [Int] = [50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
  enum Section: Int {
    case prependIndicator
    case appendIndicator
    case messages
  }
  
  struct Const {
    static let maxiumRange: Int = 100
    static let minimumRange: Int = 0
    static let forceLoadDelay: TimeInterval = 2.0
    static let moreItemCount: Int = 10
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.leadingScreensForBatching = 3.0
    
    collectionNode.delegate = self
    collectionNode.dataSource = self
    
    log.info(viewModel.makeNewSession())
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange, chatNode: ASCollectionNode) -> ASLayoutSpec {
    
    let messageLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: .infinity, left: 0, bottom: self.keyboardVisibleHeight + 0.0, right: 0), child: self.messageInputNode)
    let messageOverlayLayout = ASOverlayLayoutSpec(child: collectionNode, overlay: messageLayout)
    return ASInsetLayoutSpec(insets: .zero, child: messageOverlayLayout)
  }
}

extension ChatRoomViewController: ChatNodeDataSource{
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return 3
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    switch section{
    case Section.prependIndicator.rawValue:
      return self.pagingStatus == .prepending ? 1 : 0
      case Section.appendIndicator.rawValue:
      return self.pagingStatus == .appending ? 1 : 0
    case Section.messages.rawValue:
      return self.items.count
    default:
      return 0
    }
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
    switch indexPath.section {
    case Section.appendIndicator.rawValue:
      return ChatLoadingIndicatorNode()
    case Section.messages.rawValue:
      return ChatCellNode()
    case Section.prependIndicator.rawValue:
      return ChatLoadingIndicatorNode()
    default: return ASCellNode()
    }
  }
}

extension ChatRoomViewController: ChatNodeDelegate{
  func shouldAppendBatchFetch(for chatNode: ASCollectionNode) -> Bool {
    return true
  }
  
  func shouldPrependBatchFetch(for chatNode: ASCollectionNode) -> Bool {
    return true
  }
  
  func chatNode(_ chatNode: ASCollectionNode, willBeginAppendBatchFetchWith context: ASBatchContext) {
    log.debug("call append")
//    self.collectionNode.reloadSections(IndexSet(integer: Section.appendIndicator.rawValue))
    self.completeBatchFetching(true, endDirection: .none)
  }
  
  func chatNode(_ chatNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
    log.debug("call prepend")
     self.collectionNode.reloadSections(IndexSet(integer: Section.prependIndicator.rawValue))
    self.completeBatchFetching(true, endDirection: .none)
  }
}



