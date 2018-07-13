////
////  MockMessage.swift
////  ZIP_ios
////
////  Created by park bumwoo on 2018. 1. 31..
////  Copyright © 2018년 park bumwoo. All rights reserved.
////
//
//import UIKit
//import MessageKit
//
//struct MockMessage: MessageType {
//  var kind: MessageKind
//
//
//  var messageId: String
//  var sender: Sender
//  var sentDate: Date
//
//
//  init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
//    self.kind = kind
//    self.sender = sender
//    self.messageId = messageId
//    self.sentDate = date
//  }
//
//  init(text: String, sender: Sender, messageId: String, date: Date) {
//    self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
//  }
//
//  init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
//    self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
//  }
//
//  init(image: UIImage, sender: Sender, messageId: String, date: Date) {
//    self.init(kind: .photo(MediaItem), sender: sender, messageId: messageId, date: date)
//  }
//
//  init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
//    let url = URL(fileURLWithPath: "")
//    self.init(kind: .video(file: url, thumbnail: thumbnail), sender: sender, messageId: messageId, date: date)
//  }
//
//  init(emoji: String, sender: Sender, messageId: String, date: Date) {
//    self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
//  }
//
//}
