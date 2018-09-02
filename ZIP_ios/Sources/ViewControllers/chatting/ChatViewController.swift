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


class ChatViewController: UIViewController{
  
  var session: MQTTSession?
  let disposeBag = DisposeBag()
  
  let button: UIButton = {
    let button = UIButton()
    button.setTitle("보내기!!!", for: .normal)
    button.backgroundColor = .blue
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setting()
    view.addSubview(button)
    
    button.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    
    button.rx
      .tap
      .subscribeNext(weak: self) { (retainSelf) -> (()) -> Void in
        return { _ in
          retainSelf.session?.publishData("data".data(using: .utf8), onTopic: "go-mqtt/sample", retain: false, qos: MQTTQosLevel.exactlyOnce, publishHandler: { (err) in
            if err != nil {
              log.error(err ?? "e")
            }else{
              log.info("send message")
            }
          })
        }
      }.disposed(by: disposeBag)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session?.close(disconnectHandler: { (err) in
      if err != nil {
        log.error(err)
      }
    })
  }
  
  func setting(){
    guard let newSession = MQTTSession() else {
      log.info("세션 생성 불가 에러처리 필요 ")
      return
    }
    session = newSession
    newSession.delegate = self
    
    let transport = MQTTCFSocketTransport()
    transport.host = "192.168.0.6"
    newSession.transport = transport
    transport.delegate = self
    session?.delegate = self
    session?.connect()
  }
}

extension ChatViewController: MQTTSessionDelegate, MQTTTransportDelegate{
  func mqttTransport(_ mqttTransport: MQTTTransportProtocol, didReceiveMessage message: Data) {
    log.info(String(data: message, encoding: .utf8))
  }
  
  func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
    
    log.info("Received \(String(data: data, encoding: .utf8)) on:\(topic) q\(qos) r\(retained) m\(mid)")
  }
  
  func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
    switch eventCode{
    case .connected:
      log.info("connected")
      session?.subscribe(toTopic: "go-mqtt/sample", at: .exactlyOnce)
    case .connectionClosed:
      log.info("connectionClosed")
    case .connectionClosedByBroker:
      log.info("connectionClosedByBroker")
    case .connectionError:
      log.info("connectionError")
    case .connectionRefused:
      log.info("connectionRefused")
    case .protocolError:
      log.info("protocolError")
    }
  }
}
