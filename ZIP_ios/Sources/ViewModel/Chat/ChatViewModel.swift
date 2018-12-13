//
//  ChatViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 12/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RMQClient
import RxRealm
import RealmSwift
import MessageKit
import RxSwift
import RxCocoa
import PopupDialog


class ChatViewModel: NSObject{
  
  let realm = try! Realm()
  private var isPopUp = false
  private let disposeBag = DisposeBag()
  private let roomID: Int
  private let userID: Int
  private let parentViewController: UIViewController
  private let popUp = PublishRelay<(title:String,message:String)>()
  
  lazy var conn: RMQConnection = {
    let connection = RMQConnection(uri: "amqp://qkrqjadn:1q2w3e4r@192.168.1.11:5672", delegate: self)
    return connection
  }()
  
  lazy var channel: RMQChannel = {
    return conn.createChannel()
  }()
  
  lazy var exchange: RMQExchange = {
    return channel.fanout("Room_\(roomID)", options: .durable)
  }()
  
  lazy var queue: RMQQueue = {
    return channel.queue("Room_\(roomID)_User_\(userID)", options: .durable)
  }()
  let subscribeMessage = PublishRelay<RMQMessage>()
  let publishMessage = PublishRelay<(text:String, displayName: String)>()
  let messagesSubject = BehaviorRelay<[MessageType]>(value: [])
  lazy var messages = realm.objects(MessageRealm.self)

  init(roomID: Int, userID: Int, parentViewController: UIViewController){
    self.roomID = roomID
    self.userID = userID
    self.parentViewController = parentViewController
    super.init()
    queue.bind(exchange)
    
    messagesSubject.accept(Array(messages)[(messages.endIndex-11)...messages.endIndex-1].map{$0.ToMessageItem()})
    
//    Observable.array(from: messages)
//      .subscribeNext(weak: self) { (weakSelf) -> (Array<MessageRealm>) -> Void in
//        return {array in
//          log.info(array.prefix(3))
//        }
//      }.disposed(by: disposeBag)
    
  
    let manualAck = RMQBasicConsumeOptions()
    queue.subscribe(manualAck){[weak self] m in
      guard let weakSelf = self else {return}
      weakSelf.subscribeMessage.accept(m)
    }
 
    publishMessage
      .map{ data in
      return try? JSONEncoder().encode(MessageModel(id: "\(userID)", displayName: data.displayName, messageId: "", sentDate: Date(), kind: "text", value: data.text.data(using: .utf8) ?? Data()))
      }.unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (Data) -> Void in
        return {data in
          weakSelf.exchange.publish(data)
        }
      }.disposed(by: disposeBag)

    
    let subscribeMessageShare = subscribeMessage
      .observeOn(SerialDispatchQueueScheduler(qos: .default))
      .do(onNext: {[weak self] (m) in
        self?.channel.ack(m.deliveryTag)
      })
      .share()
    
    subscribeMessageShare
      .map{try JSONDecoder().decode(MessageModel.self, from: $0.body).ToMessageItem()}
      .scan(messagesSubject.value) { $0 + $1 }
      .bind(to: messagesSubject)
      .disposed(by: disposeBag)
    
    subscribeMessageShare
      .map{ try JSONDecoder().decode(MessageModel.self, from: $0.body).ToRealmModel()}
      .subscribe(Realm.rx.add())
      .disposed(by: disposeBag)
    
    popUp
      .filter{_ in return !self.isPopUp}
      .observeOn(MainScheduler.asyncInstance)
      .subscribeNext(weak: self) { (weakSelf) -> ((title: String, message: String)) -> Void in
      return { data in
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.titleFont = UIFont.AppleSDGothicNeoRegular(size: 16)
        dialogAppearance.titleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dialogAppearance.messageFont = UIFont.AppleSDGothicNeoBold(size: 16)
        dialogAppearance.messageColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let popup = PopupDialog(title: data.title,
                                message: data.message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true)
        popup.addButtons([Init(DefaultButton(title: "확인"){ [weak self] in
          self?.parentViewController.navigationController?.popViewController(animated: true)
        }){$0.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)},Init(DefaultButton(title: "취소"){ [weak self] in
          self?.parentViewController.navigationController?.popViewController(animated: true)
        }){$0.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)}])
        weakSelf.parentViewController.present(popup, animated: true, completion: nil)
        weakSelf.isPopUp = true
      }
      }.disposed(by: disposeBag)
  }
  
  func start(){
    conn.start()
  }

  deinit {
    conn.close()
  }
}

extension ChatViewModel: RMQConnectionDelegate{
  func connection(_ connection: RMQConnection!, failedToConnectWithError error: Error!) {
    log.info(error)
  }
  
  func connection(_ connection: RMQConnection!, disconnectedWithError error: Error!) {
    // 접속 오류로 네비게이션 뒤로 이동
    popUp.accept(("접속 에러","서버와 접속이 끊켰습니다.\n 뒤로 가시겠습니까?"))
  }
  
  func connection(_ connection: RMQConnection!, failedToWriteWithError error: Error!) {
    log.error(error)
  }
  
  func startingRecovery(with connection: RMQConnection!) {
    // 복구 시작
    log.info("startingRecovery")
  }
  
  func recoveredConnection(_ connection: RMQConnection!) {
    // 재연결
    DispatchQueue.main.async {[weak self] in
      self?.parentViewController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    isPopUp = false
  }
  
  func willStartRecovery(with connection: RMQConnection!) {
    // 복구 시작전
    log.info("willStartRecovery")
  }
  
  func channel(_ channel: RMQChannel!, error: Error!) {
    log.info("channel")
  }
}
