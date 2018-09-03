//
//  ChatRoomViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import UIKit
import AsyncDisplayKit


class ChatRoomViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate{
  

  struct State{
    var itemCount: Int
    var fetchingMore: Bool
    static let empty = State(itemCount: 20, fetchingMore: false)
  }
  
  enum Action {
    case beginBatchFetch
    case endBatchFetch(resultCount: Int)
  }
  
  
  var tableNode: ASTableNode {
    return node as! ASTableNode
  }
  
  fileprivate(set) var state: State = .empty
  
  init() {
    super.init(node: ASTableNode())
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableNode.delegate = self
    tableNode.dataSource = self
    tableNode.allowsSelection = false
    tableNode.view.separatorStyle = .none
    
  }
    
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    let node = ChatCellNode()
    
    return node
  }
  
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }
  
}
