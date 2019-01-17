////
////  ChatViewModel.swift
////  ZIP_ios
////
////  Created by xiilab on 12/12/2018.
////  Copyright © 2018 park bumwoo. All rights reserved.
////
//
//
//import RxRealm
//import RealmSwift
//import MessageKit
//import RxSwift
//import RxCocoa
//import PopupDialog
//
//class ChatViewModel: NSObject{
//  
//  private var isPopUp = false
//  private let disposeBag = DisposeBag()
//  private let roomID: Int64
//  private let userID: Int64
//  private let parentViewController: UIViewController
//  private let popUp = PublishRelay<(title:String,message:String)>()
//  private var firstIndex = 0
//  private lazy var conn: RMQConnection = {
//    let connection = RMQConnection(uri: "amqp://qkrqjadn:1q2w3e4r@www.sumwhere.kr:5672", delegate: self)
//    return connection
//  }()
//  
//  private lazy var channel: RMQChannel = {
//    return conn.createChannel()
//  }()
//  
//  private lazy var exchange: RMQExchange = {
//    return channel.fanout("Room_\(roomID)", options: .durable)
//  }()
//  
//  private lazy var queue: RMQQueue = {
//    return channel.queue("Room_\(roomID)_User_\(userID)", options: .durable)
//  }()
//  
//  public let subscribeMessage = PublishRelay<RMQMessage>()
//  public let publishMessage = PublishRelay<(text:String, displayName: String)>()
//  public let messagesSubject = BehaviorRelay<[MessageType]>(value: [])
//  public let loadMoreAction = PublishRelay<Void>()
//
//  init(roomID: Int64, userID: Int64, parentViewController: UIViewController){
//    self.roomID = roomID
//    self.userID = userID
//    self.parentViewController = parentViewController
//    super.init()
//    queue.bind(exchange)
//    
//    realmInit()
//    
//    let manualAck = RMQBasicConsumeOptions()
//    queue.subscribe(manualAck){[weak self] m in
//      guard let weakSelf = self else {return}
//      weakSelf.subscribeMessage.accept(m)
//    }
//    
//    publishMessage
//      .map{ data in
//        return try? JSONEncoder().encode(MessageModel(id: "\(userID)", displayName: data.displayName, messageId: "", sentDate: Date(), kind: "text", value: data.text.data(using: .utf8) ?? Data()))
//      }.unwrap()
//      .subscribeNext(weak: self) { (weakSelf) -> (Data) -> Void in
//        return {data in
//          weakSelf.exchange.publish(data)
//        }
//      }.disposed(by: disposeBag)
//    
//    let subscribeMessageShare = subscribeMessage
//      .observeOn(SerialDispatchQueueScheduler(qos: .default))
//      .do(onNext: {[weak self] (m) in
//        self?.channel.ack(m.deliveryTag)
//      }).share()
//    
//    subscribeMessageShare
//      .map{try JSONDecoder().decode(MessageModel.self, from: $0.body).ToMessageItem()}
//      .map{[unowned self] model in return self.messagesSubject.value + model}
//      .bind(to: messagesSubject)
//      .disposed(by: disposeBag)
//    
//    subscribeMessageShare
//      .map{ try JSONDecoder().decode(MessageModel.self, from: $0.body).ToRealmModel()}
//      .subscribeNext(weak: self, { (weakSelf) -> (MessageRealm) -> Void in
//        return {message in
//          let realm = try! Realm()
//          let room = realm.objects(MessageRoom.self)
//          let messages = room.filter("roomID = \(roomID)").first?.messages
//          try! realm.write {
//            messages?.append(message)
//          }
//        }
//      })
//      .disposed(by: disposeBag)
//    
//    popUp
//      .filter{_ in return !self.isPopUp}
//      .observeOn(MainScheduler.asyncInstance)
//      .subscribeNext(weak: self) { (weakSelf) -> ((title: String, message: String)) -> Void in
//      return { data in
//        let dialogAppearance = PopupDialogDefaultView.appearance()
//        dialogAppearance.titleFont = UIFont.AppleSDGothicNeoRegular(size: 16)
//        dialogAppearance.titleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        dialogAppearance.messageFont = UIFont.AppleSDGothicNeoBold(size: 16)
//        dialogAppearance.messageColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        
//        let popup = PopupDialog(title: data.title,
//                                message: data.message,
//                                buttonAlignment: .horizontal,
//                                transitionStyle: .zoomIn,
//                                tapGestureDismissal: true,
//                                panGestureDismissal: true)
//        popup.addButtons([Init(DefaultButton(title: "확인"){ [weak self] in
//          self?.parentViewController.navigationController?.popViewController(animated: true)
//        }){$0.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)},Init(DefaultButton(title: "취소"){ [weak self] in
//          self?.parentViewController.navigationController?.popViewController(animated: true)
//        }){$0.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)}])
//        weakSelf.parentViewController.present(popup, animated: true, completion: nil)
//        weakSelf.isPopUp = true
//      }
//      }.disposed(by: disposeBag)
//
//    loadMoreAction
//      .flatMapLatest {[unowned self] () -> Observable<[MessageType]> in
//        
//        if self.firstIndex == 0 {
//          return Observable.just([])
//        }
//        let realm = try! Realm()
//        let rooms = realm.objects(MessageRoom.self).filter("roomID = \(roomID)").first
//        guard let messages = rooms?.messages else {return Observable.just([])}
//        let copyValue = self.firstIndex
//        if self.firstIndex - 20 > 0 {
//          self.firstIndex -= 20
//          return Observable.just(Array(messages)[copyValue - 20..<copyValue].map{$0.ToMessageItem()})
//        }else {
//          self.firstIndex = 0
//          return Observable.just(Array(messages)[messages.startIndex..<copyValue].map{$0.ToMessageItem()})
//        }
//      }.map{[unowned self] models in
//         return models + self.messagesSubject.value
//      }.bind(to: messagesSubject)
//      .disposed(by: disposeBag)
//  }
//
//
//  private func realmInit(){
//    do {
//      let config = Realm.Configuration(
//        // Set the new schema version. This must be greater than the previously used
//        // version (if you've never set a schema version before, the version is 0).
//        schemaVersion: 1,
//        // Set the block which will be called automatically when opening a Realm with
//        // a schema version lower than the one set above
//        migrationBlock: { migration, oldSchemaVersion in
//          // We haven’t migrated anything yet, so oldSchemaVersion == 0
//          if (oldSchemaVersion < 1) {
//            // Nothing to do!
//            // Realm will automatically detect new properties and removed properties
//            // And will update the schema on disk automatically
//          }
//      })
//      // Tell Realm to use this new configuration object for the default Realm
//      Realm.Configuration.defaultConfiguration = config
//      let realm = try Realm()
//      let rooms = realm.objects(MessageRoom.self).filter("roomID = \(roomID)")
//      if rooms.count == 0 {
//        let messageRoom = MessageRoom()
//        messageRoom.roomID = Int(roomID)
//        try realm.write {
//          realm.add(messageRoom)
//        }
//      }
//      if let messages = rooms.first?.messages {
//        if messages.count > 20 {
//          log.info("messageCount:\(messages.count)")
//          messagesSubject.accept(Array(messages)[(messages.endIndex-21)..<messages.endIndex].map{$0.ToMessageItem()})
//          firstIndex = messages.endIndex-21
//        }else{
//          messagesSubject.accept(Array(messages).map{$0.ToMessageItem()})
//          firstIndex = messages.startIndex
//        }
//      }
//    } catch let error {
//      log.error(error)
//    }
//  }
//    
//  
//  func start(){
//    conn.start()
//  }
//
//  deinit {
//    conn.close()
//  }
//}
//
//extension ChatViewModel: RMQConnectionDelegate{
//  func connection(_ connection: RMQConnection!, failedToConnectWithError error: Error!) {
//    log.info(error)
//  }
//  
//  func connection(_ connection: RMQConnection!, disconnectedWithError error: Error!) {
//    // 접속 오류로 네비게이션 뒤로 이동
//    popUp.accept(("접속 에러","서버와 접속이 끊켰습니다.\n 뒤로 가시겠습니까?"))
//  }
//  
//  func connection(_ connection: RMQConnection!, failedToWriteWithError error: Error!) {
//    log.error(error)
//  }
//  
//  func startingRecovery(with connection: RMQConnection!) {
//    // 복구 시작
//    log.info("startingRecovery")
//  }
//  
//  func recoveredConnection(_ connection: RMQConnection!) {
//    // 재연결
//    DispatchQueue.main.async {[weak self] in
//      self?.parentViewController.presentedViewController?.dismiss(animated: true, completion: nil)
//    }
//    isPopUp = false
//  }
//  
//  func willStartRecovery(with connection: RMQConnection!) {
//    // 복구 시작전
//    log.info("willStartRecovery")
//  }
//  
//  func channel(_ channel: RMQChannel!, error: Error!) {
//    log.error(error)
//    log.info("channel")
//  }
//}
