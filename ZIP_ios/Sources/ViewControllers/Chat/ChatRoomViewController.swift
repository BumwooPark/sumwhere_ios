//
//  ChatRoomViewController2.swift
//  ZIP_ios
//
//  Created by xiilab on 11/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//


// exchange: Room ID
// Queue: {RoomID}_{UserID}

import RxSwift
import RxCocoa
import MessageKit
import RMQClient
import MessageInputBar

final class ChatRoomViewController: MessagesViewController{
  
  private let disposeBag = DisposeBag()
  private let roomId: Int
  private let userId: Int
  private let sender: Sender
  private let refreshControl = UIRefreshControl()
  lazy var viewModel: ChatViewModel = ChatViewModel(roomID: roomId, userID: userId, parentViewController: self)
  
  var messages: [MessageType] = []
  
  init(roomID: Int, userID: Int){
    self.sender = Sender(id: "\(userID)", displayName: "benpark")
    self.roomId = roomID
    self.userId = userID
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.start()
    messagesCollectionView.addSubview(refreshControl)
    scrollsToBottomOnKeyboardBeginsEditing = true
    maintainPositionOnKeyboardFrameChanged = true
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messageInputBar.delegate = self
  
    viewModel
      .messagesSubject
      .observeOn(MainScheduler.asyncInstance)
      .filter{$0.count > 0}
      .subscribeNext(weak: self) { (weakSelf) -> ([MessageType]) -> Void in
        return {models in
          log.info(models)
        }
      }.disposed(by: disposeBag)
    
    
    viewModel.messagesSubject
      .observeOn(MainScheduler.instance)
      .filter{$0.count > 11}
      .subscribeNext(weak: self) { (weakSelf) -> ([MessageType]) -> Void in
        return {models in
          weakSelf.messagesCollectionView.performBatchUpdates({
            log.info("first")
            weakSelf.messagesCollectionView.insertSections([models.count - 1])
            if models.count >= 2 {
              log.info("second")
              weakSelf.messagesCollectionView.reloadSections([models.count - 2])
            }
            
            log.info(weakSelf.messagesCollectionView.numberOfSections)
          }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
              self?.messagesCollectionView.scrollToBottom(animated: true)
            }
          })
        }
    }.disposed(by: disposeBag)
  }

  func isLastSectionVisible() -> Bool {
    guard !viewModel.messagesSubject.value.isEmpty else { return false }
    let lastIndexPath = IndexPath(item: 0, section: viewModel.messagesSubject.value.count - 1)
    return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
  }
}

extension ChatRoomViewController: MessagesDataSource{
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return viewModel.messagesSubject.value.count
  }
  
  func currentSender() -> Sender {
    return self.sender
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return viewModel.messagesSubject.value[indexPath.section]
  }
}

extension ChatRoomViewController: MessagesDisplayDelegate {
  func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
    return [.url, .address, .phoneNumber, .date, .transitInformation]
  }
  
  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    
    let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(tail, .curved)
  }
//  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//    return isFromCurrentSender(message: message) ? .primaryColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
//  }
}

extension ChatRoomViewController: MessagesLayoutDelegate{
  func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 18
  }
  
  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 20
  }
  
  func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 16
  }
}

extension ChatRoomViewController: MessageInputBarDelegate{
  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    viewModel.publishMessage.accept((text, self.sender.displayName))
  }
}
