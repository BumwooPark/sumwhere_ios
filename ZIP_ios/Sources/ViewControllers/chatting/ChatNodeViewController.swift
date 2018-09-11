//
//  ChatRoomViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import RxKeyboard
import RxSwift


public protocol ChatNodeDelegate: ASCollectionDelegate {
  func shouldAppendBatchFetch(for chatNode: ASCollectionNode) -> Bool
  func shouldPrependBatchFetch(for chatNode: ASCollectionNode) -> Bool
  func chatNode(_ chatNode: ASCollectionNode,
                willBeginAppendBatchFetchWith context: ASBatchContext)
  func chatNode(_ chatNode: ASCollectionNode,
                willBeginPrependBatchFetchWith context: ASBatchContext)
}

public protocol ChatNodeDataSource: ASCollectionDataSource {}

class ChatNodeViewController: ASViewController<ASDisplayNode>, ASCollectionDataSource {
  
  public enum BatchFetchDirection: UInt{
    case append
    case prepend
    case none
  }
  
  enum Action {
    case beginBatchFetch
    case endBatchFetch(resultCount: Int)
  }
  
  public enum PaginationStatus {
    case initial
    case appending
    case prepending
    case some
    
    var isLoading: Bool {
      switch self {
      case .appending, .prepending:
        return true
      default:
        return false
      }
    }
  }

  private let disposeBag = DisposeBag()
  private lazy var batchFetchingContext = ASBatchContext()
  open var isPagingStatusEnable: Bool = true
  open var keyboardVisibleHeight: CGFloat = 0.0
  open var hasNextPrependItem: Bool = true
  open var hasNextAppendItems: Bool = true
  open var pagingStatus: PaginationStatus = .initial
  open var leadingScreensForBatching: CGFloat {
    get {
      return self.collectionNode.leadingScreensForBatching
    }
    set(newValue) {
      self.collectionNode.leadingScreensForBatching = newValue
    }
  }
  
  lazy var collectionNode: ASCollectionNode = {
    let layout = TestFlowLayout()
    let node = ASCollectionNode(collectionViewLayout: layout)
    return node
  }()
  
  init() {
    super.init(node: ASDisplayNode())
    self.node.automaticallyManagesSubnodes = true 
    self.node.layoutSpecBlock = { (_, constrainedSize) -> ASLayoutSpec in
      return self.layoutSpecThatFits(constrainedSize, chatNode: self.collectionNode)
    }
    self.setupChatRangeTuningParameters()
  }
  
  open func setupChatRangeTuningParameters() {
    self.collectionNode.setTuningParameters(ASRangeTuningParameters(leadingBufferScreenfuls: 1.5,
                                                                    trailingBufferScreenfuls: 1.5),
                                            for: .full,
                                            rangeType: .display)
    self.collectionNode.setTuningParameters(ASRangeTuningParameters(leadingBufferScreenfuls: 2,
                                                                    trailingBufferScreenfuls: 2),
                                            for: .full,
                                            rangeType: .preload)
  }
  
  deinit {
    self.collectionNode.delegate = nil
    self.collectionNode.dataSource = nil
  }
  
  open func layoutSpecThatFits(_ constrainedSize: ASSizeRange,
                               chatNode: ASCollectionNode) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: chatNode)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionNode.alwaysBounceVertical = true
    collectionNode.delegate = self
    collectionNode.dataSource = self
    collectionNode.allowsSelection = false
    collectionNode.view.keyboardDismissMode = .onDrag
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: {[weak self] (height) in
        
        self?.keyboardVisibleHeight = height
        
        log.info(height)
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
          self?.node.setNeedsLayout()
          self?.node.layoutIfNeeded()
        }, completion: nil)
      }).disposed(by: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }
  
  func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
    
    return true
  }
  
  fileprivate static func fetchDataWithCompletion(_ completion: @escaping (Int) -> Void) {
    let time = DispatchTime.now() + Double(Int64(TimeInterval(NSEC_PER_SEC) * 1.0)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time) {
      let resultCount = Int(arc4random_uniform(20))
      completion(resultCount)
    }
  }
}
extension ChatNodeViewController{
  open func completeBatchFetching(_ complated: Bool, endDirection: BatchFetchDirection) {
    switch endDirection {
    case .append:
      self.hasNextAppendItems = false
    case .prepend:
      self.hasNextPrependItem = false
    default:
      break
    }
    
    switch self.pagingStatus {
    case .appending, .prepending:
      self.pagingStatus = .some
    default: break
    }
    
    self.batchFetchingContext.completeBatchFetching(complated)
  }
}

extension ChatNodeViewController: ASCollectionDelegate{}

extension ChatNodeViewController: UIScrollViewDelegate{
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
    log.info(collectionNode.visibleNodes)
//    log.debug(ASInterfaceStateIncludesVisible(self.interfaceState))
//    log.debug(ASInterfaceStateIncludesMeasureLayout(self.interfaceState))
//    log.debug(ASInterfaceStateIncludesPreload(self.interfaceState))
    
    guard let chatDelegate = self.collectionNode.delegate as? ChatNodeDelegate,
      ASInterfaceStateIncludesVisible(self.interfaceState) else {return}
    self.collectionNode.updateCurrentRange(with: .full)
    
    self.beginChatNodeBatch(scrollView, chatDelegate: chatDelegate)
  }
  
  func beginChatNodeBatch(_ scrollView: UIScrollView,
                          chatDelegate: ChatNodeDelegate){
    
    guard !self.pagingStatus.isLoading else {return}
    
    if scrollView.isDragging, scrollView.isTracking{
      return
    }
    
    let scrollVelocity = scrollView.panGestureRecognizer.velocity(in: super.view)
    
    let scope = shouldFetchBatch(for: scrollView,
                                 offset: scrollView.contentOffset.y,
                                 scrollDirection: scrollDirection(scrollVelocity),
                                 velocity: scrollVelocity)
    
    switch scope{
    case .append:
      guard chatDelegate.shouldAppendBatchFetch(for: self.collectionNode),
        self.hasNextAppendItems else {return}
      self.batchFetchingContext.beginBatchFetching()
      if isPagingStatusEnable {
        self.pagingStatus = .appending
      }
      chatDelegate.chatNode(self.collectionNode, willBeginAppendBatchFetchWith: self.batchFetchingContext)
    case .prepend:
      guard chatDelegate.shouldPrependBatchFetch(for: self.collectionNode)
        , self.hasNextPrependItem else {return}
      self.batchFetchingContext.beginBatchFetching()
      if isPagingStatusEnable {
        self.pagingStatus = .prepending
      }
      chatDelegate.chatNode(self.collectionNode, willBeginPrependBatchFetchWith: self.batchFetchingContext)
    case .none:
      break
    }
  }
  
  private func scrollDirection(_ scrollVelocity: CGPoint) -> ASScrollDirection {
    if scrollVelocity.y < 0.0 {
      return .down
    } else if scrollVelocity.y > 0.0 {
      return .up
    } else {
      return ASScrollDirection(rawValue: 0)
    }
  }
  
  private func shouldFetchBatch(for scrollView: UIScrollView,
                                offset: CGFloat,
                                scrollDirection: ASScrollDirection,
                                velocity: CGPoint) -> BatchFetchDirection {
    
    guard !self.batchFetchingContext.isFetching(), scrollView.window != nil else{return .none}
    let bounds: CGRect = scrollView.bounds
    let leadingScreens: CGFloat = self.collectionNode.leadingScreensForBatching
    
    guard leadingScreens > 0.0, !bounds.isEmpty else {return .none}
    
    let contentSize: CGSize = scrollView.contentSize
    let viewLength = bounds.size.height
    let contentLength = contentSize.height
    
    if contentLength < viewLength{
      switch scrollDirection{
      case .down:
        return .prepend
      case .up:
        return .append
      default: return .none
      }
    }
    
    let triggerDistance = viewLength * leadingScreens
    let remainingDistance = contentLength - viewLength - offset
    
    switch scrollDirection {
    case .down:
      return remainingDistance <= triggerDistance ? .append : .none
    case .up:
      return offset < triggerDistance ? .prepend : .none
    default:
      return .none
    }
  }
}
