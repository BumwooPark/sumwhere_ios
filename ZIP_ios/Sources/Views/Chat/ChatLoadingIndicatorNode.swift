//
//  LoadingCellNode.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import AsyncDisplayKit

class ChatLoadingIndicatorNode: ASCellNode {
  
  lazy var indicatorNode: ASDisplayNode = {
    let node = ASDisplayNode(viewBlock: {
      let view = UIActivityIndicatorView(style: .gray)
      view.hidesWhenStopped = true
      return view
    })
    return node
  }()
  
  override init() {
    super.init()
    self.automaticallyManagesSubnodes = true
    self.style.preferredSize = .init(width: UIScreen.main.bounds.width, height: 100.0)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASCenterLayoutSpec(centeringOptions: .XY,
                              sizingOptions: [],
                              child: indicatorNode)
  }
  
  override func didEnterVisibleState() {
    super.didEnterVisibleState()
    guard let view = indicatorNode.view as? UIActivityIndicatorView else { return }
    view.startAnimating()
    view.transform = CGAffineTransform(scaleX: 0, y: 0)
    UIView.animate(withDuration: 0.5, animations: {
      view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    })
  }
  
  override func didExitVisibleState() {
    super.didExitVisibleState()
    guard let view = indicatorNode.view as? UIActivityIndicatorView else { return }
    view.stopAnimating()
    UIView.animate(withDuration: 0.5, animations: {
      view.transform = CGAffineTransform(scaleX: 0, y: 0)
    })
  }
}
