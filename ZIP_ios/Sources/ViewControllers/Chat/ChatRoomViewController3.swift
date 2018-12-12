////
////  ChatRoomViewController.swift
////  ZIP_ios
////
////  Created by xiilab on 2018. 9. 5..
////  Copyright © 2018년 park bumwoo. All rights reserved.
////
//
//
//import RxSwift
//import CocoaMQTT
//
//class ChatRoomViewController: ChatNodeViewController{
//  
//  private let disposeBag = DisposeBag()
//  private let mqtt: CocoaMQTT
//  private let userId: Int
//  private let roomId: Int64
//  
//  var items: [String] = ["hi","hi"]
//  lazy var messageInputNode: InputBoxNode = {
//    let node = InputBoxNode()
//    node.style.alignSelf = .end
//    node.setupDefaultMessageBox()
//    return node
//  }()
//  
//  enum Section: Int {
//    case prependIndicator
//    case messages
//    case appendIndicator
//  }
//  
//  struct Const {
//    static let maxiumRange: Int = 100
//    static let minimumRange: Int = 0
//    static let forceLoadDelay: TimeInterval = 2.0
//    static let moreItemCount: Int = 10
//  }
//  
//  init(_ mqtt: CocoaMQTT,_ UserID: Int,_ RoomID: Int64) {
//    self.mqtt = mqtt
//    self.userId = UserID
//    self.roomId = RoomID
//    super.init()
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    self.tabBarController?.tabBar.isHidden = true
//  }
//  
//  override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillDisappear(animated)
//    self.tabBarController?.tabBar.isHidden = false
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    self.leadingScreensForBatching = 3.0
//    
//    collectionNode.delegate = self
//    collectionNode.dataSource = self
//    
//    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "메뉴", style: .plain, target: nil, action: nil)
//    rxBind()
//  }
//  
//  func rxBind(){
//    
//    messageInputNode
//      .textNode
//      .textView
//      .rx
//      .text
//      .unwrap()
//      .map{$0.count > 0}
//      .bind(to: messageInputNode.sendNode.rx.isEnabled)
//      .disposed(by: disposeBag)
//
//    let sendAction = messageInputNode
//      .sendNode
//      .rx
//      .controlEvent(.touchUpInside)
//      .asObservable()
//      .share()
//    
//    sendAction
//      .map{[weak self] _ in
//      return self?.messageInputNode.textNode.textView.text.count
//    }.unwrap()
//      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
//        return { count in
//          weakSelf.messageInputNode.sendNode.isEnabled = (count > 0) ? true : false
//        }
//    }.disposed(by: disposeBag)
//    
//    sendAction
//      .map{[unowned self] _ in
//        return self.messageInputNode.textNode.textView.text
//      }.unwrap()
//      .subscribeNext(weak: self) { (weakSelf) -> (String) -> Void in
//        return { message in
//          let encoder = JSONEncoder()
//          let data = try? encoder.encode(MessagePayLoad(id: nil, messageType: .string, data: message.data(using: .utf8) ?? Data()))
//            weakSelf.mqtt.publish(CocoaMQTTMessage(topic: "chat/\(weakSelf.roomId)/\(weakSelf.userId)", payload: [UInt8](data ?? Data())))
//        }
//      }.disposed(by: disposeBag)
//    
//    
//    mqtt.rx.didConnectAck
//      .subscribeNext(weak: self) { (weakSelf) -> (CocoaMQTTConnAck) -> Void in
//        return { ack in
//          switch ack{
//          case .accept:
//            log.info("accept")
//            weakSelf.mqtt.subscribe("chat/\(weakSelf.roomId)", qos: CocoaMQTTQOS.qos2)
//          case .badUsernameOrPassword:
//            log.info(#function)
//          case .identifierRejected:
//            log.info("reject")
//          case .notAuthorized:
//            log.info("not AUther")
//          case .reserved:
//            log.info("reserved")
//          case .serverUnavailable:
//            log.info("server Una")
//          case .unacceptableProtocolVersion:
//            log.info("version")
//          }
//        }
//    }.disposed(by: disposeBag)
//    
//    mqtt.rx
//      .mqttDidDisconnect
//      .subscribe(onNext: { (_) in
//      log.info("disconnect")
//    }).disposed(by: disposeBag)
//    
//    mqtt.rx.didReceiveMessage
//      .map{$0.0.string}
//      .unwrap()
//      .map{[$0]}
//      .scan(self.items) { $0 + $1}
//      .subscribeNext(weak: self, { (weakSelf) -> ([String]) -> Void in
//        return { data in
//          weakSelf.items = data
//          weakSelf.collectionNode.reloadSections(IndexSet(integer: Section.messages.rawValue))
//          weakSelf.collectionNode.scrollToItem(at: IndexPath(item: weakSelf.items.count - 1, section: 1), at: .bottom, animated: true)
//        }
//      }).disposed(by: disposeBag)
//    
//    mqtt.rx.didPublishMessage.subscribe(onNext: { (_) in
//      log.info("publish")
//    }).disposed(by: disposeBag)
//  }
//
//  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange, chatNode: ASCollectionNode) -> ASLayoutSpec {
//    let collectionLayout = super.layoutSpecThatFits(constrainedSize, chatNode: chatNode)
//    collectionNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageInputNode.style.height.value, right: 0)
//    let messageLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: .infinity, left: 0, bottom: self.keyboardVisibleHeight + 0.0, right: 0), child: self.messageInputNode)
//    let messageOverlayLayout = ASOverlayLayoutSpec(child: collectionLayout, overlay: messageLayout)
//    return ASInsetLayoutSpec(insets: .zero, child: messageOverlayLayout)
//  }
//}
//
//extension ChatRoomViewController: ChatNodeDataSource{
//  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
//    return 3
//  }
//  
//  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
//    switch section{
//    case Section.prependIndicator.rawValue:
//      return self.pagingStatus == .prepending ? 1 : 0
//      case Section.appendIndicator.rawValue:
//      return self.pagingStatus == .appending ? 1 : 0
//    case Section.messages.rawValue:
//      return self.items.count
//    default:
//      return 0
//    }
//  }
//  
//  func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
//    switch indexPath.section {
//    case Section.appendIndicator.rawValue:
//      return ChatLoadingIndicatorNode()
//    case Section.messages.rawValue:
//      let node = ChatCellNode()
//      node.messageNode.attributedText = NSAttributedString(string: items[indexPath.item])
//      return node
//    case Section.prependIndicator.rawValue:
//      return ChatLoadingIndicatorNode()
//    default: return ASCellNode()
//    }
//  }
//}
//
//extension ChatRoomViewController: ChatNodeDelegate{
//  func shouldAppendBatchFetch(for chatNode: ASCollectionNode) -> Bool {
//    return false
//  }
//  
//  func shouldPrependBatchFetch(for chatNode: ASCollectionNode) -> Bool {
//    return false
//  }
//  
//  func chatNode(_ chatNode: ASCollectionNode, willBeginAppendBatchFetchWith context: ASBatchContext) {
//    log.debug("call append")
////    self.collectionNode.reloadSections(IndexSet(integer: Section.appendIndicator.rawValue))
////    self.completeBatchFetching(true, endDirection: .none)
//  }
//  
//  func chatNode(_ chatNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
//    log.debug("call prepend")
////     self.collectionNode.reloadSections(IndexSet(integer: Section.prependIndicator.rawValue))
////    self.completeBatchFetching(true, endDirection: .none)
//  }
//}
//
