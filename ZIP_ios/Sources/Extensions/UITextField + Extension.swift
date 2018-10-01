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
