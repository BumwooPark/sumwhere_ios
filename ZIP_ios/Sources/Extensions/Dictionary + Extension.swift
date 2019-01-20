//
//  Dictionary + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 18/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation
import MessageKit
import SwiftDate

extension Dictionary where Key == String {
  func ToChatMessage() -> ChatMessage? {
    
    guard let contents = self["contents"] as? String,
      let isRead = self["isRead"] as? Bool,
      let kind = self["kind"] as? String,
      let messageId = self["messageId"] as? String,
      let sender = self["sender"] as? String,
      let sentDate = self["sentDate"] as? String else {return nil}
    
    switch kind {
    case "text":
      return ChatMessage(sender: Sender(id: sender, displayName: ""), messageId: "", sentDate: sentDate.toISODate()?.date ?? Date(), kind: MessageKind.text(contents), isRead: isRead)
    default:
      return nil
    }
  }
}
