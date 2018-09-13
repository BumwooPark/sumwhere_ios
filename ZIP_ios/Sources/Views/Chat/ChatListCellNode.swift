//
//  ChatListCellNode.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit

final class ChatListCellNode: ASCellNode{
  
  lazy var profileImage: ASImageNode = {
    let node = ASImageNode()
    node.style.preferredSize = CGSize(width: 50, height: 50)
    node.cornerRadius = 25
    node.clipsToBounds = true
    node.backgroundColor = .blue
    return node
  }()
  
  lazy var tripNameNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "오사카", attributes: [.font: UIFont.NotoSansKRBold(size: 20)])
    return node
  }()
  
  lazy var nameNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "범우")
    return node
  }()
  
  lazy var dateNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "2018.09.02")
    return node
  }()
  
  lazy var messageNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "같이 가실래요 ????")
    return node
  }()
  
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
    selectionStyle = .none
  }
  
  override func didLoad() {
    super.didLoad()
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let profileInsetLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10), child: profileImage)
    let profileLayout = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: [], child: profileInsetLayout)
    profileLayout.style.flexShrink = 1
    messageNode.style.flexGrow = 1
    
    let messageName = ASStackLayoutSpec(direction: .vertical, spacing: 12, justifyContent: .spaceAround, alignItems: .start, children: [nameNode,messageNode])
    messageName.style.flexGrow = 1
    
    let dateInsetLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), child: dateNode)
    let dateLayout = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .start, sizingOption: [], child: dateInsetLayout)
    
    let bottomLayout = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .spaceBetween, alignItems: .stretch, children: [profileLayout,messageName,dateLayout])
    
    let tripInsetLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0), child: tripNameNode)
    let tripNameCenterLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: tripInsetLayout)
    
    return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .spaceAround, alignItems: .stretch, children: [tripNameCenterLayout,bottomLayout])
  }
}
