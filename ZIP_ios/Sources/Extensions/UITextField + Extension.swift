//
//  UITextField + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 28..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

extension UITextField {
  func setZIPClearButton(){
    let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    clearButton.setImage(#imageLiteral(resourceName: "deleteAll"), for: .normal)
    clearButton.contentMode = .scaleAspectFit
    clearButton.addTarget(self, action: #selector(clear(sender:)), for: .touchUpInside)
    self.rightView = clearButton
    self.rightViewMode = .whileEditing
  }
  @objc func clear(sender : AnyObject) {
    self.text = ""
  }
}

class UITextFieldPadding : UITextField {
  
  let padding: UIEdgeInsets
  override init(frame: CGRect) {
    self.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    super.init(frame: frame)
  }
 
  init(padding: UIEdgeInsets) {
    self.padding = padding
    super.init(frame: .zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
