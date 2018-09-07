//
//  InputBoxNode.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import AsyncDisplayKit
import RxSwift

class InputBoxNode: ASDisplayNode{
  
  let disposeBag = DisposeBag()
  
  var textHeight: CGFloat = 50{
    didSet{
      log.info(textHeight)
    }
  }
  
  lazy var textNode: ASEditableTextNode = {
    let node = ASEditableTextNode()
    node.cornerRadius = 5
    node.clipsToBounds = true
    node.borderColor = UIColor.lightGray.cgColor
    node.borderWidth = 0.5
    node.placeholderEnabled = true
    node.attributedPlaceholderText = NSAttributedString(string: "메시지 입력",
                                                        attributes: [.font: UIFont.NotoSansKRMedium(size: 15),.foregroundColor: UIColor.lightGray])
    node.textView.font = UIFont.NotoSansKRMedium(size: 15)
    node.textContainerInset = UIEdgeInsets(top: 7, left: 10, bottom: 0, right: 0)
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
    
    textNode.textView.rx
      .didChange
      .map{ [weak self] _ -> CGFloat in
        guard let node = self?.textNode else {return 0}
        let number = (node.textView.contentSize.height - node.textView.textContainerInset.top - node.textView.textContainerInset.bottom) / (node.textView.font?.lineHeight)!
        return CGFloat(Int(number))
    }.distinctUntilChanged()
      .subscribeNext(weak: self) { (weakSelf) -> (CGFloat) -> Void in
        return { value in
          log.info("called")
          weakSelf.textHeight = 50 * value
          weakSelf.setNeedsLayout()
          weakSelf.layoutIfNeeded()
        }
    }.disposed(by: disposeBag)
  }
  
  func setMessageBoxHeight(){
    self.style.height = .init(unit: .points, value: 50)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let inputLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), child: textNode)
    let buttonLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), child: sendNode)
    let lay = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: [], child: buttonLayout)
    lay.style.flexShrink = 1 
    return ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .stretch, children: [inputLayout,lay])
    
  }
}
