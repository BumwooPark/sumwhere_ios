//
//  ChatCellNode.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit
import SwiftyImage

final class ChatCellNode: ASCellNode {
  
  let profileImageNode: ASNetworkImageNode = {
    let image = ASNetworkImageNode()
    image.backgroundColor = .blue
    
    return image
  }()
  
  let tempProfileImage: ASImageNode = {
    let image = ASImageNode()
    image.image = UIImage.resizable().color(.blue).image
    image.cornerRadius = 25
    image.style.preferredSize = CGSize(width: 50, height: 50)
    image.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(5.0, .white)
    return image
  }()
  
  let bubbleImage: ASImageNode = {
    let image = ASImageNode()
    image.image = #imageLiteral(resourceName: "bubble").resizableImage(withCapInsets: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), resizingMode: .stretch)
    image.style.height = .init(unit: .points, value: 50.0)
    image.style.maxWidth = .init(unit: .points,value: UIScreen.main.bounds.width / 3)
//    image.contentMode = .scaleAspectFill
    return image
  }()
  
  let messageNode: ASTextNode = {
    let node = ASTextNode()
    node.attributedText = NSAttributedString(string: "안녕하세요 !!\n안녕", attributes: [.font : UIFont.NotoSansKRMedium(size: 16)])
    return node
  }()
  
  override init() {
    super.init()
    addSubnode(tempProfileImage)
    addSubnode(messageNode)
    addSubnode(bubbleImage)
  }
  
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    let overlay = ASOverlayLayoutSpec(child: bubbleImage, overlay: messageNode)
    
    let imageLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: tempProfileImage)
    let messageLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10), child: overlay)
    
    let headerStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .baselineFirst, children: [imageLayout,messageLayout])
    
    
    
    return headerStackSpec
  }
}
