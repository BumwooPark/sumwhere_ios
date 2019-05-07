//
//  SearchViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 07/05/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//



class SearchViewController: UIViewController{
  var didUpdateConstraint = false
  
  private let searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "장소 검색"
    textField.font = UIFont.AppleSDGothicNeoRegular(size: 24)
    textField.textColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    return textField
  }()
  
  private let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(searchTextField)
    view.addSubview(dividLine)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      
      searchTextField.snp.makeConstraints { (make) in
        make.right.left.equalToSuperview().inset(38)
        make.height.equalTo(29)
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      }
      
      dividLine.snp.makeConstraints { (make) in
        make.left.right.equalTo(searchTextField)
        make.height.equalTo(1)
        make.top.equalTo(searchTextField.snp.bottom).offset(13)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
