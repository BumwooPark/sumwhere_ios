//
//  InputBoxNode.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit

class InputBoxNode: ASDisplayNode{
  
  lazy var textNode: ASEditableTextNode = {
    let node = ASEditableTextNode()
    node.cornerRadius = 10
    node.clipsToBounds = true
    node.backgroundColor = .blue
    node.textView.text = "hisjhlaijhlai"
    return node
  }()
  
  lazy var sendNode: ASButtonNode = {
    let node = ASButtonNode()
    node.setAttributedTitle(NSAttributedString(string: "전송"), for: .normal)
    node.style.preferredSize = CGSize(width: 50, height: 50)
    node.cornerRadius = 10
    node.clipsToBounds = true
    node.backgroundColor = .red
    return node
  }()
  
  override init() {
    super.init()
    backgroundColor = .white
    automaticallyManagesSubnodes = true
  }
  
  override func didLoad() {
    super.didLoad()
  }
  
  public func setMessageBoxHeight(){
    self.style.height = .init(unit: .points, value: 50)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    let inputLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: textNode)
    inputLayout.style.flexGrow = 1
    let buttonLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), child: sendNode)
    let lay = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: [], child: buttonLayout)
    
    let stackLayout = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .end, alignItems: .stretch, children: [inputLayout,lay])
    return stackLayout
    
  }
}
