//
//  ChatRoomViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import UIKit
import AsyncDisplayKit


class ChatRoomViewController: ASViewController<ASDisplayNode>, ASCollectionDataSource, ASCollectionDelegate, ChatCollectionViewLayoutDelegate{


  struct State{
    var itemCount: Int
    var fetchingMore: Bool
    static let empty = State(itemCount: 10, fetchingMore: false)
  }
  
  enum Action {
    case beginBatchFetch
    case endBatchFetch(resultCount: Int)
  }
  
  fileprivate(set) var state: State = .empty{
    didSet{
      log.info(state)
    }
  }
  
  open var leadingScreensForBatching: CGFloat {
    get {
      return self.collectionNode.leadingScreensForBatching
    }
    set(newValue) {
      self.collectionNode.leadingScreensForBatching = newValue
    }
  }
  
  lazy var collectionNode: ASCollectionNode = {
    let layout = ChatFlowLayout()
    layout.delegate = self
    let node = ASCollectionNode(collectionViewLayout: layout)
    return node
  }()
  
  
  init() {
    super.init(node: ASDisplayNode())
    self.node.automaticallyManagesSubnodes = true 
    self.node.layoutSpecBlock = { (_, constrainedSize) -> ASLayoutSpec in
      return self.layoutSpecThatFits(constrainedSize, chatNode: self.collectionNode)
    }
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
  }
    
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }
  
  func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {

    return true
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
    DispatchQueue.main.async {
      let oldState = self.state
      self.state = ChatRoomViewController.handleAction(.beginBatchFetch, fromState: oldState)
      self.renderDiff(oldState)
    }
    
    ChatRoomViewController.fetchDataWithCompletion { resultCount in
      let action = Action.endBatchFetch(resultCount: resultCount)
      let oldState = self.state
      self.state = ChatRoomViewController.handleAction(action, fromState: oldState)
      self.renderDiff(oldState)
      context.completeBatchFetching(true)
    }
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    var count = state.itemCount
    if state.fetchingMore {
      count += 1
    }
    return count
  }
  
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return 1
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
    let rowCount = self.collectionNode(collectionNode, numberOfItemsInSection: 0)
    if state.fetchingMore && indexPath.row == rowCount - 1 {
      let node = TailLoadingCellNode()
      node.style.width = .init(unit: .points, value: collectionNode.frame.width)
      node.style.height = ASDimensionMake(44.0)
      return node;
    }
    let node = ChatCellNode()
    return node
  }
  
  func collectionView(_ collectionView: UICollectionView, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 100)
  }
  
  
  func renderDiff(_ oldState: State){
    self.collectionNode.performBatchUpdates({
      
      // Add or remove items
      let rowCountChange = state.itemCount - oldState.itemCount
      if rowCountChange > 0 {
        let indexPaths = (oldState.itemCount..<state.itemCount).map { index in
          IndexPath(row: index, section: 0)
        }
        
        collectionNode.insertItems(at: indexPaths)
      } else if rowCountChange < 0 {
        assertionFailure("Deleting rows is not implemented. YAGNI.")
      }
      
      // Add or remove spinner.
      if state.fetchingMore != oldState.fetchingMore {
        if state.fetchingMore {
          // Add spinner.
          let spinnerIndexPath = IndexPath(row: state.itemCount, section: 0)
          collectionNode.insertItems(at: [ spinnerIndexPath ])
        } else {
          // Remove spinner.
          let spinnerIndexPath = IndexPath(row: oldState.itemCount, section: 0)
          collectionNode.deleteItems(at: [ spinnerIndexPath ])
          
        }
      }
    }, completion:nil)
  }
  
  fileprivate static func fetchDataWithCompletion(_ completion: @escaping (Int) -> Void) {
    let time = DispatchTime.now() + Double(Int64(TimeInterval(NSEC_PER_SEC) * 1.0)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time) {
      let resultCount = Int(arc4random_uniform(20))
      completion(resultCount)
    }
  }
  
  fileprivate static func handleAction(_ action: Action, fromState state: State) -> State {
    var state = state
    switch action {
    case .beginBatchFetch:
      state.fetchingMore = true
    case let .endBatchFetch(resultCount):
      state.itemCount += resultCount
      state.fetchingMore = false
    }
    return state
  }
}
