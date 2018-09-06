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
    return session
  }()
  
  private lazy var transport: MQTTCFSocketTransport = {
    let transport = MQTTCFSocketTransport()
    return transport
  }()
  
  init(host: String, subscribeTopic: String) {
    self.subscribeTopic = subscribeTopic
    super.init()
    self.transport.host = host
    self.recvMessage = session?.rx.mqttMessage
    self.mqttState = session?.rx.mqttEvent.share().debug()
    
    session?.rx.mqttEvent
      .filter{$0 == .connected}
      .map{_ in return ()}
      .bind(onNext: subscribe)
      .disposed(by: disposeBag)
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
  
  private func publishBehavior(topic: String){
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
            DelegateProxyType, MQTTSessionDelegate, MQTTTransportDelegate{
  
  func mqttTransport(_ mqttTransport: MQTTTransportProtocol, didReceiveMessage message: Data) {
    messageSubject.onNext(message)
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
    eventSubject.onNext(eventCode)
  }
}



