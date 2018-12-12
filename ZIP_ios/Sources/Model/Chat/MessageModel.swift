//
//  ChatMessageModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 16..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
import MessageKit

struct MessageModel: Codable{
  let id: String
  let displayName: String
  let messageId: String
  let sentDate: Date
  let kind: String
  let value: Data
  
  enum CodingKeys: String, CodingKey {
    case id
    case displayName
    case messageId
    case sentDate
    case kind
    case value
  }
  
  init(id: String, displayName: String, messageId: String, sentDate: Date, kind: String, value: Data) {
    self.id = id
    self.displayName = displayName
    self.messageId = messageId
    self.sentDate = sentDate
    self.kind = kind
    self.value = value
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    displayName = try container.decode(String.self, forKey: .displayName)
    messageId = try container.decode(String.self, forKey: .messageId)
    sentDate = try container.decode(Date.self, forKey: .sentDate)
    kind = try container.decode(String.self, forKey: .kind)
    value = try container.decode(Data.self, forKey: .value)
  }
  
  func ToMessageItem() -> MessageType {
    var kindValue: MessageKind!
    switch kind{
    case "text":
      kindValue = MessageKind.text(String(decoding: value, as: UTF8.self))
    case "attributedText":
      kindValue = MessageKind.attributedText(NSAttributedString(string: String(decoding: value, as: UTF8.self)))
    case "emoji":
      kindValue = MessageKind.emoji(String(decoding: value, as: UTF8.self))
    default:
      kindValue = MessageKind.text(String(decoding: value, as: UTF8.self))
    }
    return MessageItem(sender: Sender(id: id, displayName: displayName), messageId: messageId, sentDate: sentDate, kind: kindValue)
  }
}

struct MessageItem: MessageType{
  var sender: Sender
  var messageId: String
  var sentDate: Date
  var kind: MessageKind
}
