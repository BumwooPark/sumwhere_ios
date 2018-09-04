//
//  LoadingCellNode.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit

final class TailLoadingCellNode: ASCellNode {
  let spinner = SpinnerNode()
  let text = ASTextNode()
  
  override init() {
    super.init()
    
    addSubnode(text)
    text.attributedText = NSAttributedString(
      string: "Loading…",
      attributes: [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.lightGray
      ])
    addSubnode(spinner)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 16,
      justifyContent: .center,
      alignItems: .center,
      children: [ text, spinner ])
  }
}

final class SpinnerNode: ASDisplayNode {
  var activityIndicatorView: UIActivityIndicatorView {
    return view as! UIActivityIndicatorView
  }
  
  override init() {
    super.init()
    setViewBlock {
      UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }
    
    // Set spinner node to default size of the activitiy indicator view
    self.style.preferredSize = CGSize(width: 20.0, height: 20.0)
  }
  
  override func didLoad() {
    super.didLoad()
    
    activityIndicatorView.startAnimating()
  }
}
