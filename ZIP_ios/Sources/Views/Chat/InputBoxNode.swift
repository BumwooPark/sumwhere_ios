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
  
  typealias Node = InputBoxNode
  let disposeBag = DisposeBag()
  
  fileprivate var minimumMessageBoxHeight: CGFloat = 50.0
  fileprivate var maximumVisibleMessageNumberOfLines: Int = 6
  
  
  lazy var textNode: ASEditableTextNode = {
    let node = ASEditableTextNode()
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
    node.isEnabled = false
    node.style.preferredSize = CGSize(width: 50, height: 50)
    node.style.alignSelf = .end
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
        var number: CGFloat = (node.textView.contentSize.height - node.textView.textContainerInset.top - node.textView.textContainerInset.bottom) / (node.textView.font?.lineHeight)!
        number = CGFloat(min(self?.maximumVisibleMessageNumberOfLines ?? 0, Int(number)))
        return CGFloat(Int(number)) - 1
      }.distinctUntilChanged()
      .subscribeNext(weak: self) { (weakSelf) -> (CGFloat) -> Void in
        return { value in
          
          var calcultedHeight = value * (weakSelf.textNode.textView.font?.pointSize ?? 0.0)
          calcultedHeight += weakSelf.minimumMessageBoxHeight
          weakSelf.style.height = .init(unit: .points, value: calcultedHeight)
          weakSelf.setNeedsLayout()
          weakSelf.layoutIfNeeded()
        }
    }.disposed(by: disposeBag)
  }
  
  func setupDefaultMessageBox(){
    setMessageBoxHeight(50.0, maxiumNumberOfLine: 6, isRounded: true)
  }
  
  func setMessageBoxHeight(_ minimumHeight: CGFloat,
                           maxiumNumberOfLine: Int,
                           isRounded: Bool) {
    self.style.height = .init(unit: .points, value: minimumHeight)
    self.minimumMessageBoxHeight = minimumHeight
    self.maximumVisibleMessageNumberOfLines = maxiumNumberOfLine
    
    guard isRounded else { return }
    self.textNode.clipsToBounds = true
    let textNodeSize = self.textNode.calculateSizeThatFits(UIScreen.main.bounds.size)
    self.textNode.cornerRadius = textNodeSize.height / 2
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    let inputLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), child: textNode)
    let buttonLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), child: sendNode)
    let lay = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: [], child: buttonLayout)
    inputLayout.style.flexGrow = 1
    inputLayout.style.flexShrink = 1
    return ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .stretch, children: [inputLayout,lay])
  }
}
