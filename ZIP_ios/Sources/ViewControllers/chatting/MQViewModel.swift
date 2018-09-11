//
//  ChatViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import MQTTClient
import RxSwift
import RxCocoa

class MQViewModel: NSObject {
  
  open var publish = PublishSubject<Data>()
  open var mqttState: Observable<MQTTSessionEvent>?
  open var recvMessage: Observable<Data>?
  
  private let disposeBag = DisposeBag()
  private let subscribeTopic: String
  
  private let session: MQTTSession? = {
    let session = MQTTSession()
    session?.protocolLevel = .version311
    session?.userName = "qkrqjadn"
    session?.password = "1q2w3e4r"
    return session
  }()
  
  private lazy var transport: MQTTCFSocketTransport = {
    let transport = MQTTCFSocketTransport()
    return transport
  }()
  
  init(host: String, port: UInt32, subscribeTopic: String) {
    self.subscribeTopic = subscribeTopic
    super.init()
    self.transport.host = host
    self.transport.port = port
    self.recvMessage = session?.rx.mqttMessage.share()
    self.mqttState = session?.rx.mqttEvent.share()
    self.session?.transport = transport
    
    session?.rx.mqttEvent
      .subscribe(onNext: { (event) in
        log.info(event)
      }).disposed(by: disposeBag)
    
    session?.rx.mqttEvent
      .filter{$0 == .connected}
      .map{_ in return ()}
      .bind(onNext: subscribe)
      .disposed(by: disposeBag)
    session?.subscribe(toTopic: subscribeTopic, at: .exactlyOnce)
    
  }
  
  deinit {
    session?.closeAndWait(2)
  }
  
  func makeNewSession() -> Bool {
    guard session?.connect() != nil else  {return false}
    return true
  }
  
  private func subscribe(){
    session?.subscribe(toTopic: subscribeTopic, at: .exactlyOnce)
  }
  
  func publishBehavior(topic: String){
    //TODO: 전송 실패에 대한 부분 생각
    publish.subscribeNext(weak: self) { (weakSelf) -> (Data) -> Void in
      return { message in
        weakSelf.session?.publishData(message, onTopic: topic, retain: true, qos: .exactlyOnce)
      }
    }.disposed(by: disposeBag)
  }
}

extension Reactive where Base: MQTTSession {
  private var proxyDelegate: RxMQTTDelegateProxy {
    return RxMQTTDelegateProxy.proxy(for: base)
  }
  
  var mqttEvent: Observable<MQTTSessionEvent> {
    return proxyDelegate.eventSubject.asObserver()
  }
  
  var mqttMessage: Observable<Data> {
    return proxyDelegate.messageSubject.asObserver()
  }
}

fileprivate class RxMQTTDelegateProxy: DelegateProxy<MQTTSession, MQTTSessionDelegate>,
            DelegateProxyType, MQTTSessionDelegate{
  
  func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
    messageSubject.onNext(data)
  }
  
  let eventSubject = PublishSubject<MQTTSessionEvent>()
  let messageSubject = PublishSubject<Data>()
  
  init(parentObject: DelegateProxy<MQTTSession, MQTTSessionDelegate>.ParentObject) {
    super.init(parentObject: parentObject, delegateProxy: RxMQTTDelegateProxy.self)
  }
  
  static func registerKnownImplementations() {
    self.register { RxMQTTDelegateProxy(parentObject: $0)}
  }
  
  static func currentDelegate(for object: RxMQTTDelegateProxy.ParentObject) -> RxMQTTDelegateProxy.Delegate? {
    return object.delegate
  }
  
  static func setCurrentDelegate(_ delegate: RxMQTTDelegateProxy.Delegate?, to object: RxMQTTDelegateProxy.ParentObject) {
    object.delegate = delegate
  }
  
  func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
    log.info(eventCode)
    eventSubject.onNext(eventCode)
  }
}



