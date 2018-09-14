//
//  MQTTUtil.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 14..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import CocoaMQTT
import RxSwift
import RxCocoa

protocol MQTTBuilder{
  static func newBuild(with ID: String) -> MQTTBuilder
  func newURL(host: String, port: UInt16) -> MQTTBuilder
  func newAccount(username: String, password: String) -> MQTTBuilder
  func keepAlive(time: UInt16) -> MQTTBuilder
  func build() -> CocoaMQTT
}

class MQTTUtil: MQTTBuilder{
  
  private var mqttClient: CocoaMQTT
  static func newBuild(with ID: String) -> MQTTBuilder{
    let client = CocoaMQTT(clientID: ID)
    return MQTTUtil(client: client)
  }
  
  func newURL(host: String, port: UInt16) -> MQTTBuilder{
    self.mqttClient.host = host
    self.mqttClient.port = port
    return self
  }
  
  func newAccount(username: String, password: String) -> MQTTBuilder {
    self.mqttClient.username = username
    self.mqttClient.password = password
    return self
  }
  
  func keepAlive(time: UInt16) -> MQTTBuilder {
    self.mqttClient.keepAlive = time
    return self
  }
  
  private init(client: CocoaMQTT) {
    self.mqttClient = client
  }
  
  func build() -> CocoaMQTT {
    return mqttClient
  }
}

extension Reactive where Base: CocoaMQTT{
  private var proxyDelegate: RxCocoaMQTTDelegateProxy{
    return RxCocoaMQTTDelegateProxy.proxy(for: base)
  }
  
  var didConnectAck: PublishSubject<CocoaMQTTConnAck>{
    return proxyDelegate.didConnectAck
  }
  var didPublishMessage: PublishSubject<(CocoaMQTTMessage,UInt16)>{
    return proxyDelegate.didPublishMessage
  }
  
  var didPublishAck: PublishSubject<UInt16>{
    return proxyDelegate.didPublishAck
  }
  
  var didReceiveMessage: PublishSubject<(CocoaMQTTMessage,UInt16)>{
    return proxyDelegate.didReceiveMessage
  }
  
  var didSubscribeTopic: PublishSubject<String>{
    return proxyDelegate.didSubscribeTopic
  }
  
  var didUnsubscribeTopic: PublishSubject<String>{
    return proxyDelegate.didUnsubscribeTopic
  }
  
  var mqttDidPing: PublishSubject<CocoaMQTT>{
    return proxyDelegate.mqttDidPing
  }
  
  var mqttDidReceivePong: PublishSubject<CocoaMQTT>{
    return proxyDelegate.mqttDidReceivePong
  }
  
  var mqttDidDisconnect: PublishSubject<CocoaMQTT>{
    return proxyDelegate.mqttDidDisconnect
  }
}

class RxCocoaMQTTDelegateProxy: DelegateProxy<CocoaMQTT, CocoaMQTTDelegate>, DelegateProxyType,CocoaMQTTDelegate{
  
  let didConnectAck = PublishSubject<CocoaMQTTConnAck>()
  let didPublishMessage = PublishSubject<(CocoaMQTTMessage,UInt16)>()
  let didPublishAck = PublishSubject<UInt16>()
  let didReceiveMessage = PublishSubject<(CocoaMQTTMessage,UInt16)>()
  let didSubscribeTopic = PublishSubject<String>()
  let didUnsubscribeTopic = PublishSubject<String>()
  let mqttDidPing = PublishSubject<CocoaMQTT>()
  let mqttDidReceivePong = PublishSubject<CocoaMQTT>()
  let mqttDidDisconnect = PublishSubject<CocoaMQTT>()
  
  static func registerKnownImplementations() {
    self.register { RxCocoaMQTTDelegateProxy(parentObject: $0)}
  }
  
  init(parentObject: DelegateProxy<CocoaMQTT, CocoaMQTTDelegate>.ParentObject) {
    super.init(parentObject: parentObject, delegateProxy: RxCocoaMQTTDelegateProxy.self)
  }
  
  static func currentDelegate(for object: CocoaMQTT) -> CocoaMQTTDelegate? {
    return object.delegate
  }
  
  static func setCurrentDelegate(_ delegate: CocoaMQTTDelegate?, to object: CocoaMQTT) {
    object.delegate = delegate
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
    didConnectAck.onNext(ack)
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    didPublishMessage.onNext((message,id))
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    didPublishAck.onNext(id)
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
    didReceiveMessage.onNext((message,id))
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
    didSubscribeTopic.onNext(topic)
  }
  
  func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    didUnsubscribeTopic.onNext(topic)
  }
  
  func mqttDidPing(_ mqtt: CocoaMQTT) {
    mqttDidPing.onNext(mqtt)
  }
  
  func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    mqttDidReceivePong.onNext(mqtt)
  }
  
  func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    if err != nil {
      mqttDidDisconnect.onError(err!)
    }else {
      mqttDidDisconnect.onNext(mqtt)
    }
  }
}
