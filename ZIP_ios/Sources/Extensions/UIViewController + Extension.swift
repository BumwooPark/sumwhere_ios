//
//  UIViewController + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 30..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

extension UIViewController {
  /// 제스쳐 인식기가 터치를 먹어버리는 현상발생
  /// cancelsTouchesInView가 default가 true인것이 원인
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard(){
    view.endEditing(true)
  }
}
