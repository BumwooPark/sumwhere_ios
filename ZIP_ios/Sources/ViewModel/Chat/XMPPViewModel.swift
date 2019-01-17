//
//  XMPPViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 16/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import XMPPFramework

enum XMPPControllerError: Error {
  case wrongUserJID
}

class XMPPController: NSObject{
  
  var xmppStream: XMPPStream
  let roomStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
  let roomJID = XMPPJID(string: "test@conference.example.com")
  let hostName: String
  let userJID: XMPPJID
  let hostPort: UInt16
  let password: String
  
  init(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws {
    guard let userJID = XMPPJID(string: userJIDString) else {
      throw XMPPControllerError.wrongUserJID
    }
    
    self.hostName = hostName
    self.userJID = userJID
    self.hostPort = hostPort
    self.password = password
    
    // Stream Configuration
    self.xmppStream = XMPPStream()
    self.xmppStream.hostName = hostName
    self.xmppStream.hostPort = hostPort
    
    self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
    self.xmppStream.myJID = userJID
    
    super.init()
    
    self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
    log.info(self.xmppStream.supportsStartTLS)
    
  }
  
  func existMCU(serviceName: String) -> Bool{
    let muc = XMPPMUC(dispatchQueue: DispatchQueue.main)
    muc.activate(xmppStream)
    muc.addDelegate(self, delegateQueue: DispatchQueue.main)
    return muc.discoverRooms(forServiceNamed: serviceName)
  }
  
  func joinRoom(){
    let room = XMPPRoom(roomStorage: XMPPRoomMemoryStorage(), jid: roomJID!)
    if !room.isJoined{
      room.join(usingNickname: "bumwoo", history: DDXMLElement(name: "go"))
    }
  }
  
  func MCUList(){
    XMPPIQ(type: "get", elementID: "conference.example.com")
  }
  
  func connect() {
    
    if !self.xmppStream.isDisconnected {
      log.info("disconnect")
      return
    }
    
    try! self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
    log.info("connecting...")
  }
  
  func sendMessage(){
    xmppStream.send(DDXMLElement(name: "h"))
  }
}

extension XMPPController: XMPPStreamDelegate{
  func xmppStreamDidConnect(_ stream: XMPPStream) {
    log.info("Stream: Connected")
    try! stream.authenticate(withPassword: self.password)
  }
  
  func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
    self.xmppStream.send(XMPPPresence())
    log.info("Stream: Authenticated")
  }
  
  func xmppStream(_ sender: XMPPStream, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
    log.info(trust)
    completionHandler(true)
  }
  
  func xmppStream(_ sender: XMPPStream, willSecureWithSettings settings: NSMutableDictionary) {
    log.info(settings)
  }
  
  func xmppStreamDidSecure(_ sender: XMPPStream) {
    log.info("didSecure")
  }
}


extension XMPPController: XMPPMUCDelegate{
  func xmppMUC(_ sender: XMPPMUC, didDiscoverRooms rooms: [Any], forServiceNamed serviceName: String) {
    log.info(rooms)
  }
  
  func xmppMUCFailed(toDiscoverServices sender: XMPPMUC, withError error: Error) {
    log.error(error)
  }
}

extension XMPPController: XMPPRoomDelegate{
  func xmppRoomDidJoin(_ sender: XMPPRoom) {
    log.info("didJoin")
  }
  
  func xmppRoomDidCreate(_ sender: XMPPRoom) {
    log.info("create")
  }
}
