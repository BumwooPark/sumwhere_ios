//
//  ChatRoomViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import SQLite
import CocoaMQTT

struct MessagePayLoad: Codable{
  enum MessageType: Int, Codable{
    case string = 0
    case image
    case map
  }
  
  let id: Int64
  let messageType: MessageType
  let message: String
}

class ChatRoomViewController: ChatNodeViewController{
  
  private let disposeBag = DisposeBag()
  private let mqtt: CocoaMQTT
  private let userId: Int
  private let roomId: Int64
  
  var items: [String] = ["hi","hi"]
  lazy var messageInputNode: InputBoxNode = {
    let node = InputBoxNode()
    node.style.alignSelf = .end
    node.setupDefaultMessageBox()
    return node
  }()
  
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
  
  init(_ UserID: Int,_ RoomID: Int64) {
    self.mqtt = MQTTUtil.newBuild(with: "client")
      .keepAlive(time: 60)
      .newAccount(username: "qkrqjadn", password: "1q2w3e4r")
      .newURL(host: "210.100.238.118", port: 18883)
      .build()
    self.userId = UserID
    self.roomId = RoomID
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.leadingScreensForBatching = 3.0
    
    collectionNode.delegate = self
    collectionNode.dataSource = self
    
    rxBind()
//    sqlliteTest()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    mqtt.connect()
  }
  
  
  func sqlliteTest() {
    
    guard let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    do {
      let db = try Connection(urls.absoluteString + "/chat.sqlite3")
      log.info(Thread.isMainThread)
      let users = Table("users")
      let id = Expression<Int64>("id")
      let name = Expression<String>("name")
      let email = Expression<String>("email")
      
      try db.run(users.create(block: { (t) in
        t.column(id, primaryKey: true)
        t.column(name)
        t.column(email, unique: true)
      }))
      
      let insert = users.insert(name <- "benpark", email <- "bumwoopark@naver.com")
      let rowid = try db.run(insert)
      for user in try db.prepare(users) {
        log.info("id: \(user[id]), name: \(user[name]), email: \(user[email])")
        // id: 1, name: Optional("Alice"), email: alice@mac.com
      }
    }catch let error {
      log.error(error)
    }
  }
  
  func rxBind(){
    
    messageInputNode
      .textNode
      .textView
      .rx
      .text
      .filterNil()
      .map{$0.count > 0}
      .bind(to: messageInputNode.sendNode.rx.isEnabled)
      .disposed(by: disposeBag)

    let sendAction = messageInputNode
      .sendNode
      .rx
      .controlEvent(.touchUpInside)
      .asObservable()
      .share()
    
    sendAction
      .map{[weak self] _ in
      return self?.messageInputNode.textNode.textView.text.count
    }.filterNil()
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return { count in
          weakSelf.messageInputNode.sendNode.isEnabled = (count > 0) ? true : false
        }
    }.disposed(by: disposeBag)
    
    sendAction
      .map{[unowned self] _ in
        return self.messageInputNode.textNode.textView.text
      }.filterNil()
      .subscribeNext(weak: self) { (weakSelf) -> (String) -> Void in
        return { message in
          let encoder = JSONEncoder()
          let data = try? encoder.encode(MessagePayLoad(id: 0, messageType: .string, message: "hello"))
            weakSelf.mqtt.publish(CocoaMQTTMessage(topic: "chat/\(weakSelf.roomId)/\(weakSelf.userId)", payload: [UInt8](data ?? Data())))
        }
      }.disposed(by: disposeBag)
    
    
    mqtt.rx.didConnectAck
      .subscribeNext(weak: self) { (weakSelf) -> (CocoaMQTTConnAck) -> Void in
        return { ack in
          switch ack{
          case .accept:
            weakSelf.mqtt.subscribe("chat/\(weakSelf.roomId)", qos: CocoaMQTTQOS.qos2)
          default:
            break
          }
        }
    }.disposed(by: disposeBag)
    
    mqtt.rx.didReceiveMessage
      .map{$0.0.string}
      .filterNil()
      .map{[$0]}
      .scan(self.items) { $0 + $1}
      .subscribeNext(weak: self, { (weakSelf) -> ([String]) -> Void in
        return { data in
          weakSelf.items = data
          weakSelf.collectionNode.reloadSections(IndexSet(integer: Section.messages.rawValue))
          weakSelf.collectionNode.scrollToItem(at: IndexPath(item: weakSelf.items.count - 1, section: 1), at: .bottom, animated: true)
        }
      }).disposed(by: disposeBag)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange, chatNode: ASCollectionNode) -> ASLayoutSpec {
    let collectionLayout = super.layoutSpecThatFits(constrainedSize, chatNode: chatNode)
    collectionNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageInputNode.style.height.value, right: 0)
    let messageLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: .infinity, left: 0, bottom: self.keyboardVisibleHeight + 0.0, right: 0), child: self.messageInputNode)
    let messageOverlayLayout = ASOverlayLayoutSpec(child: collectionLayout, overlay: messageLayout)
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

extension ChatRoomViewController: CocoaMQTTDelegate {
  // Optional ssl CocoaMQTTDelegate
  func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
    TRACE("trust: \(trust)")
    /// Validate the server certificate
    ///
    /// Some custom validation...
    ///
    /// if validatePassed {
    ///     completionHandler(true)
    /// } else {
    ///     completionHandler(false)
    /// }
    completionHandler(true)
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
    TRACE("ack: \(ack)")
    
    if ack == .accept {
      mqtt.subscribe("chat/#", qos: CocoaMQTTQOS.qos1)
    }
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
    TRACE("new state: \(state)")
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    TRACE("message: \(message.string.description), id: \(id)")
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    TRACE("id: \(id)")
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
    TRACE("message: \(message.string.description), id: \(id)")
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
    TRACE("topic: \(topic)")
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    TRACE("topic: \(topic)")
  }
  
  func mqttDidPing(_ mqtt: CocoaMQTT) {
    TRACE()
  }
  
  func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    TRACE()
  }
  
  func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    TRACE("\(err.description)")
  }
  
  func TRACE(_ message: String = "", fun: String = #function) {
    let names = fun.components(separatedBy: ":")
    var prettyName: String
    if names.count == 1 {
      prettyName = names[0]
    } else {
      prettyName = names[1]
    }
    
    if fun == "mqttDidDisconnect(_:withError:)" {
      prettyName = "didDisconect"
    }
    
    print("[TRACE] [\(prettyName)]: \(message)")
  }
}

extension Optional {
  // Unwarp optional value for printing log only
  var description: String {
    if let warped = self {
      return "\(warped)"
    }
    return ""
  }
}


