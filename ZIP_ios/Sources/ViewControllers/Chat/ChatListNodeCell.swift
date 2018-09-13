//
//  ChatListNodeCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit

class ChatListNodeCell: ASCellNode{
  
  lazy var profileImageNode: ASImageNode = {
    let node = ASImageNode()
    node.style.preferredSize = CGSize(width: 50, height: 50)
    node.cornerRadius = 25
    node.clipsToBounds = true
    node.backgroundColor = .blue
    return node
  }()
  
  lazy var tripLabelNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "오사카")
    return node
  }()
  
  lazy var nameNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "범우")
    return node
  }()
  
  lazy var dateNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "2019.01.02")
    return node
  }()
  
  lazy var detailMessageNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "같이 가실래요??")
    return node
  }()
  
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
  }
  
  override func didLoad() {
    super.didLoad()
    style.width = .init(unit: .points, value: UIScreen.main.bounds.width)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let centerLayout = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [nameNode,dateNode])
    let messageLayout = ASCenterLayoutSpec(horizontalPosition: .center, verticalPosition: .start, sizingOption: [], child: detailMessageNode)
    
    let detailLayout = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .center, children: [centerLayout,messageLayout])
    
    
    profileImageNode.style.flexShrink = 1
    let profileLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: profileImageNode)
    
    detailLayout.style.flexGrow = 1
    let bottomLayout = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .stretch, children: [profileLayout, detailLayout])
    bottomLayout.style.alignSelf = .start
    
    let totalLayout = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .center, children: [tripLabelNode,bottomLayout])
    return totalLayout
  }
}
