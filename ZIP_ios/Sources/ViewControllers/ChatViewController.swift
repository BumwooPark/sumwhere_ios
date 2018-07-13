////
////  chatViewController.swift
////  ZIP_ios
////
////  Created by park bumwoo on 2017. 12. 18..
////  Copyright © 2017년 park bumwoo. All rights reserved.
////
//
//import UIKit
//import MessageKit
//
//class ChatViewController: MessagesViewController{
//  
//  
////  var messages = []
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    self.navigationItem.title = "수다방"
//    messagesCollectionView.alwaysBounceVertical = true
//    messagesCollectionView.messagesDataSource = self
//    messagesCollectionView.messagesLayoutDelegate = self
//    messagesCollectionView.messagesDisplayDelegate = self
//    messagesCollectionView.messageCellDelegate = self
//    messageInputBar.delegate = self
//    messageInputBar.sendButton.setTitle("전송", for: .normal)
//    messageInputBar.inputTextView.placeholder = "말걸어 줄래?"
//    scrollsToBottomOnKeybordBeginsEditing = true
//    slack()
//  }
//  
//  func slack() {
//    defaultStyle()
//    messageInputBar.backgroundColor = .white
//    messageInputBar.isTranslucent = false
//    messageInputBar.inputTextView.backgroundColor = .clear
//    messageInputBar.inputTextView.layer.borderWidth = 0
//    let items = [
//      makeButton(named: "ic_camera").onTextViewDidChange { button, textView in
//        button.isEnabled = textView.text.isEmpty
//      },
//      makeButton(named: "ic_at").onSelected {
//        $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        print("@ Selected")
//      },
//      makeButton(named: "ic_hashtag").onSelected {
//        $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        print("# Selected")
//      },
//      .flexibleSpace,
//      makeButton(named: "ic_library").onTextViewDidChange { button, textView in
//        button.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        button.isEnabled = textView.text.isEmpty
//      },
//      messageInputBar.sendButton
//        .configure {
//          $0.layer.cornerRadius = 8
//          $0.layer.borderWidth = 1.5
//          $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
//          $0.setTitleColor(.white, for: .normal)
//          $0.setTitleColor(.white, for: .highlighted)
//          $0.setSize(CGSize(width: 52, height: 30), animated: true)
//        }.onDisabled {
//          $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
//          $0.backgroundColor = .white
//        }.onEnabled {
//          $0.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//          $0.layer.borderColor = UIColor.clear.cgColor
//        }.onSelected {
//          // We use a transform becuase changing the size would cause the other views to relayout
//          $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        }.onDeselected {
//          $0.transform = CGAffineTransform.identity
//      }
//    ]
//    items.forEach { $0.tintColor = .lightGray }
//    
//    // We can change the container insets if we want
//    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
//    
//    // Since we moved the send button to the bottom stack lets set the right stack width to 0
//    messageInputBar.setRightStackViewWidthConstant(to: 0, animated: true)
//    
//    // Finally set the items
//    messageInputBar.setStackViewItems(items, forStack: .bottom, animated: true)
//  }
//  
//  func defaultStyle() {
//    let newMessageInputBar = MessageInputBar()
//    newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//    newMessageInputBar.delegate = self
//    messageInputBar = newMessageInputBar
//    reloadInputViews()
//  }
//  
//  func iMessage() {
//    defaultStyle()
//    messageInputBar.isTranslucent = false
//    messageInputBar.backgroundColor = .white
//    messageInputBar.separatorLine.isHidden = true
//    messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//    messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
//    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
//    messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
//    messageInputBar.inputTextView.layer.borderWidth = 1.0
//    messageInputBar.inputTextView.layer.cornerRadius = 16.0
//    messageInputBar.inputTextView.layer.masksToBounds = true
//    messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//    messageInputBar.setRightStackViewWidthConstant(to: 36, animated: true)
//    messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
//    messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//    messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//    messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
//    messageInputBar.sendButton.image = #imageLiteral(resourceName: "icon-shape")
//    messageInputBar.sendButton.title = nil
//    messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
//    messageInputBar.sendButton.backgroundColor = .clear
//    messageInputBar.textViewPadding.right = -38
//  }
//  
//  func makeButton(named: String) -> InputBarButtonItem {
//    return InputBarButtonItem()
//      .configure {
//        $0.spacing = .fixed(10)
//        $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
//        $0.setSize(CGSize(width: 30, height: 30), animated: true)
//      }.onSelected {
//        $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//      }.onDeselected {
//        $0.tintColor = UIColor.lightGray
//      }.onTouchUpInside { _ in
//        print("Item Tapped")
//    }
//  }
//}
//
//
//
//extension ChatViewController: MessagesDataSource {
//  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//    return 3
//  }
//  
//  func currentSender() -> Sender {
//    return Sender(id: "any_unique_id", displayName: "Steven")
//  }
//  
//  func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
//    return messages.count
//  }
//  
//  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//    return messages[indexPath.section]
//  }
//  
//  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//    let name = message.sender.displayName
//    return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
//  }
//}
//
//extension ChatViewController: MessagesDisplayDelegate,MessagesLayoutDelegate{
//  func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//    return 200
//  }
//  
//  
//  func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//    return isFromCurrentSender(message: message) ? .darkText : .darkText
//  }
//  
//  
//  
//  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//    return .white
//  }
//  
//  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//    return MessageStyle.bubbleOutline(.red)
//  }
//  
//  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//    return CGSize(width: 40, height: 40)
//  }
//  
//  func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
//    if isFromCurrentSender(message: message) {
//      return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
//    } else {
//      return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
//    }
//  }
//  
//  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//    
//    return CGSize(width: messagesCollectionView.bounds.width, height: 10)
//  }
//  
//  func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
//    return Avatar(image: nil, initials: "hi")
//  }
//  
//  func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
//    return AvatarPosition(horizontal: .natural, vertical: .messageTop)
//  }
//  
//  
////  func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
////    if isFromCurrentSender(message: message) {
////      return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
////    } else {
////      return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
////    }
////  }
//}
//
//extension ChatViewController: MessageInputBarDelegate{
//  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//    
//    let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
//    self.messages.append(MockMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date()))
//    messagesCollectionView.insertSections([messages.count - 1])
//    
//    inputBar.inputTextView.text = String()
//    messagesCollectionView.scrollToBottom(animated: true)
//  }
//}
//
//extension ChatViewController: MessageCellDelegate {
//}
//
//
