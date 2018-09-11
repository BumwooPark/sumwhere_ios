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
    let viewModel = MQViewModel(host: "210.100.238.118", port: 18883, subscribeTopic: "go-mqtt/sample")
    return viewModel
  }()
  
  lazy var messageInputNode: InputBoxNode = {
    let node = InputBoxNode()
    node.style.alignSelf = .end
    node.setupDefaultMessageBox()
    return node
  }()
  
  var items: [String] = ["hi","hi"]
  enum Section: Int {
    case prependIndicator
    case messages
    case appendIndicator
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
    viewModel.publishBehavior(topic: "go-mqtt/sample")
    viewModel.makeNewSession()
    rxBind()
  }
  
  func rxBind(){
    
    messageInputNode.sendNode
      .rx.controlEvent(.touchUpInside)
      .asObservable()
      .map{[unowned self] _ in
        return self.messageInputNode.textNode.textView.text.data(using: .utf8)
    }.filterNil().debug()
      .bind(to: viewModel.publish)
      .disposed(by: disposeBag)
  
    viewModel.mqttState?.subscribe(onNext: { (event) in
      log.info(event)
    }).disposed(by: disposeBag)
    
    viewModel
      .recvMessage?
      .map{data in
      return String(data: data, encoding: .utf8)
    }.filterNil()
      .map{[$0]}
      .scan(self.items, accumulator: { (data, message)  in
        return data + message
      })
      .subscribeNext(weak: self, { (weakSelf) -> ([String]) -> Void in
        return { data in
          weakSelf.items = data
          weakSelf.collectionNode.reloadSections(IndexSet(integer: Section.messages.rawValue))
        }
      }).disposed(by: disposeBag)
  }
  

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange, chatNode: ASCollectionNode) -> ASLayoutSpec {
    collectionNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageInputNode.style.height.value, right: 0)
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
      let node = ChatCellNode()
      node.messageNode.attributedText = NSAttributedString(string: items[indexPath.item])
      return node
    case Section.prependIndicator.rawValue:
      return ChatLoadingIndicatorNode()
    default: return ASCellNode()
    }
  }
}

extension ChatRoomViewController: ChatNodeDelegate{
  func shouldAppendBatchFetch(for chatNode: ASCollectionNode) -> Bool {
    return false
  }
  
  func shouldPrependBatchFetch(for chatNode: ASCollectionNode) -> Bool {
    return false
  }
  
  func chatNode(_ chatNode: ASCollectionNode, willBeginAppendBatchFetchWith context: ASBatchContext) {
    log.debug("call append")
//    self.collectionNode.reloadSections(IndexSet(integer: Section.appendIndicator.rawValue))
//    self.completeBatchFetching(true, endDirection: .none)
  }
  
  func chatNode(_ chatNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
    log.debug("call prepend")
//     self.collectionNode.reloadSections(IndexSet(integer: Section.prependIndicator.rawValue))
//    self.completeBatchFetching(true, endDirection: .none)
  }
}



