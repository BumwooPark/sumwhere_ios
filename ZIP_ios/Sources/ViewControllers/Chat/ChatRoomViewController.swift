////
////  ChatRoomViewController2.swift
////  ZIP_ios
////
////  Created by xiilab on 11/12/2018.
////  Copyright © 2018 park bumwoo. All rights reserved.
////
//
//import RxSwift
//import RxCocoa
//import MessageKit
//import MessageInputBar
//import MapKit
//
//final class ChatRoomViewController: MessagesViewController{
//  let outgoingAvatarOverlap: CGFloat = 17.5
//  private let disposeBag = DisposeBag()
//  private let roomId: Int64
//  private let userId: Int64
//  private let sender: Sender
//  private let refreshControl = UIRefreshControl()
////  lazy var viewModel: ChatViewModel = ChatViewModel(roomID: roomId, userID: userId, parentViewController: self)
//  
//  var messages: [MessageType] = []
//  
//  init(roomID: Int64, userID: Int64){
//    self.sender = Sender(id: "\(userID)", displayName: "benpark")
//    self.roomId = roomID
//    self.userId = userID
//    super.init(nibName: nil, bundle: nil)
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
////    viewModel.start()
//    messagesCollectionView.addSubview(refreshControl)
//    
//    let barButton = UIBarButtonItem()
//    barButton.image = #imageLiteral(resourceName: "icons8-menu-vertical-30.png")
//    barButton.style = .plain
//    
//    self.navigationItem.rightBarButtonItem = barButton
//    
//    
//    initSetting()
//    configureMessageCollectionView()
//    
////    viewModel
////      .messagesSubject
////      .debug()
////      .observeOn(MainScheduler.asyncInstance)
////      .bind(onNext: sectionUpdate)
////      .disposed(by: disposeBag)
////
//    
////    refreshControl
////      .rx
////      .controlEvent(UIControlEvents.valueChanged)
////      .bind(to: viewModel.loadMoreAction)
////      .disposed(by: disposeBag)
//  }
//  
//  private func sectionUpdate(models: [MessageType]){
//    messagesCollectionView.reloadDataAndKeepOffset()
//    messagesCollectionView.reloadData()
//    refreshControl.endRefreshing()
//    messagesCollectionView.scrollToBottom(animated: true)
////    log.info(messagesCollectionView.visibleCells.count)
////
////    log.info(viewModel.messagesSubject.value.count)
////    log.info(models.count)
////    if !refreshControl.isRefreshing {
////      messagesCollectionView.performBatchUpdates({
//////        messagesCollectionView.insertSections([models.count - 1])
//////        if models.count >= 2 {
//////          messagesCollectionView.reloadSections([models.count - 2])
//////        }
////      }) { [weak self](_) in
////        if self?.isLastSectionVisible() == true {
////          self?.messagesCollectionView.scrollToBottom(animated: true)
////        }
////      }
////    }else{
////      messagesCollectionView.reloadDataAndKeepOffset()
////      refreshControl.endRefreshing()
////    }
//  }
//
//  
//  private func initSetting(){
//    scrollsToBottomOnKeyboardBeginsEditing = true
//    maintainPositionOnKeyboardFrameChanged = true
//    messagesCollectionView.messagesDataSource = self
//    messagesCollectionView.messagesLayoutDelegate = self
//    messagesCollectionView.messagesDisplayDelegate = self
//    messageInputBar.delegate = self
//  }
//  
//  
//  private func configureMessageCollectionView() {
//    let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
//    layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
//    
//    // Hide the outgoing avatar and adjust the label alignment to line up with the messages
//    layout?.setMessageOutgoingAvatarSize(.zero)
//    layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
//    layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
//    
//    // Set outgoing avatar to overlap with the message bubble
//    layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
//    layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
//    layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
//    
//    layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
//    layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
//    layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
//    layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
//    
//    messagesCollectionView.messagesLayoutDelegate = self
//    messagesCollectionView.messagesDisplayDelegate = self
//    
//    configureInputBarItems()
//  }
//  
//  
//  private func configureInputBarItems() {
//    messageInputBar.isTranslucent = true
//    messageInputBar.separatorLine.isHidden = true
//    messageInputBar.inputTextView.tintColor = .black
//    messageInputBar.inputTextView.backgroundColor = .clear
//    messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//    messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
//    messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
//    messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
//    messageInputBar.inputTextView.layer.borderWidth = 1.0
//    messageInputBar.inputTextView.layer.cornerRadius = 16.0
//    messageInputBar.inputTextView.layer.masksToBounds = true
//    messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//    messageInputBar.backgroundView.backgroundColor = .white
//    messageInputBar.inputTextView.placeholder = "메시지를 입력해 주세요."
//    messageInputBar.sendButton.setTitle("hello", for: .normal)
//  }
//  
//  func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
//    return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
//  }
//  
//  func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
//    guard indexPath.section - 1 >= 0 else { return false }
//    return viewModel.messagesSubject.value[indexPath.section].sender == viewModel.messagesSubject.value[indexPath.section - 1].sender
//  }
//  
//  func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
//    guard indexPath.section + 1 < viewModel.messagesSubject.value.count else { return false }
//    return viewModel.messagesSubject.value[indexPath.section].sender == viewModel.messagesSubject.value[indexPath.section + 1].sender
//  }
//
//  func isLastSectionVisible() -> Bool {
//    guard !viewModel.messagesSubject.value.isEmpty else { return false }
//    let lastIndexPath = IndexPath(item: 0, section: viewModel.messagesSubject.value.count - 1)
//    return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
//  }
//  
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    messagesCollectionView.scrollToBottom(animated: animated)
//  }
//}
//
//extension ChatRoomViewController: MessagesDataSource{
//  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//    return viewModel.messagesSubject.value.count
//  }
//  
//  func currentSender() -> Sender {
//    return self.sender
//  }
//  
//  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//    return viewModel.messagesSubject.value[indexPath.section]
//  }
//}
//
//extension ChatRoomViewController: MessagesDisplayDelegate {
//  func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//    return isFromCurrentSender(message: message) ? .white : .darkText
//  }
//  
//  func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
//    return MessageLabel.defaultAttributes
//  }
//  
//  func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
//    return [.url, .address, .phoneNumber, .date, .transitInformation]
//  }
//  
//  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//    return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.431372549, green: 0.5843137255, blue: 0.9882352941, alpha: 1) : #colorLiteral(red: 0.9058823529, green: 0.9098039216, blue: 0.9647058824, alpha: 1)
//  }
//  
//  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//    
//    var corners: UIRectCorner = []
//    
//    if isFromCurrentSender(message: message) {
//      corners.formUnion(.topLeft)
//      corners.formUnion(.bottomLeft)
//      if !isPreviousMessageSameSender(at: indexPath) {
//        corners.formUnion(.topRight)
//      }
//      if !isNextMessageSameSender(at: indexPath) {
//        corners.formUnion(.bottomRight)
//      }
//    } else {
//      corners.formUnion(.topRight)
//      corners.formUnion(.bottomRight)
//      if !isPreviousMessageSameSender(at: indexPath) {
//        corners.formUnion(.topLeft)
//      }
//      if !isNextMessageSameSender(at: indexPath) {
//        corners.formUnion(.bottomLeft)
//      }
//    }
//    
//    return .custom { view in
//      let radius: CGFloat = 16
//      let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//      let mask = CAShapeLayer()
//      mask.path = path.cgPath
//      view.layer.mask = mask
//    }
//  }
//  
//  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//    avatarView.set(avatar: Avatar(image: nil, initials: "SS"))
//    avatarView.isHidden = isNextMessageSameSender(at: indexPath)
//  }
//  
//  func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
//    let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
//    let pinImage = #imageLiteral(resourceName: "ic_map_marker")
//    annotationView.image = pinImage
//    annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
//    return annotationView
//  }
//  
//  func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
//    return { view in
//      view.layer.transform = CATransform3DMakeScale(2, 2, 2)
//      UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
//        view.layer.transform = CATransform3DIdentity
//      }, completion: nil)
//    }
//  }
//  
//  func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
//    
//    return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
//  }
//}
//
//extension ChatRoomViewController: MessagesLayoutDelegate{
//  func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//    if isTimeLabelVisible(at: indexPath) {
//      return 18
//    }
//    return 0
//  }
//  
//  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//    if isFromCurrentSender(message: message) {
//      return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
//    } else {
//      return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
//    }
//  }
//  
//  func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//    return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
//  }
//}
//
//extension ChatRoomViewController: MessageInputBarDelegate{
//  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//    viewModel.publishMessage.accept((text, self.sender.displayName))
//    inputBar.inputTextView.text = String()
//    messagesCollectionView.scrollToBottom(animated: true)
//  }
//}
