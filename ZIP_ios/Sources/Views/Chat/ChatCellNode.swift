////
////  ChatCellNode.swift
////  ZIP_ios
////
////  Created by xiilab on 2018. 9. 3..
////  Copyright © 2018년 park bumwoo. All rights reserved.
////
//
//import AsyncDisplayKit
//import SwiftyImage
//
//final class ChatCellNode: ASCellNode {
//  
//  let profileImageNode: ASNetworkImageNode = {
//    let image = ASNetworkImageNode()
//    image.backgroundColor = .blue
//    return image
//  }()
//  
//  let tempProfileImage: ASImageNode = {
//    let image = ASImageNode()
//    image.image = UIImage.resizable().color(.blue).image
//    image.cornerRadius = 25
//    image.style.preferredSize = CGSize(width: 50, height: 50)
//    image.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(5.0, .white)
//    return image
//  }()
//  
//  let balloonNode: ASDisplayNode = {
//    let node = ASDisplayNode()
//    node.style.height = .init(unit: .points, value: 50.0)
//    node.cornerRadius = 10
//    node.style.maxWidth = .init(unit: .points,
//                                value: UIScreen.main.bounds.width / 2)
//    node.clipsToBounds = true
//    node.backgroundColor = .lightGray
//    return node
//  }()
//    
//  let messageNode: ASTextNode = {
//    let node = ASTextNode()
//    node.attributedText = NSAttributedString(string: "안녕하세요 !!\n안녕", attributes: [.font : UIFont.NotoSansKRMedium(size: 16)])
//    return node
//  }()
//  
//  override init() {
//    super.init()
//    addSubnode(balloonNode)
//    addSubnode(tempProfileImage)
//    addSubnode(messageNode)
//  }
//  
//  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//    
//    let textCenterLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: messageNode)
//    let overlay = ASOverlayLayoutSpec(child: balloonNode, overlay: textCenterLayout)
//    
//    let imageLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: tempProfileImage)
//    let messageLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10), child: overlay)
//    
//    let headerStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: [imageLayout,messageLayout])
//    
//    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .infinity), child: headerStackSpec)
//  }
//}
