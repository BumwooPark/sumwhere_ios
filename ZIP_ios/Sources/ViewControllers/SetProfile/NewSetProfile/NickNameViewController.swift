//
//  NickNameViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

final class NickNameViewController: UIViewController{
  
  var didUpdateConstraint = false
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "닉네임을 입력해 주세요"
    label.font = UIFont.NotoSansKRBold(size: 20)
    label.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    return label
  }()
  
  lazy var textField: UITextField = {
    let field = UITextField()
    field.returnKeyType = .done
    field.delegate = self
    return field
  }()
  
  let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(titleLabel)
    view.addSubview(textField)
    view.addSubview(bottomView)
    view.setNeedsUpdateConstraints()
  }
  
  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.textField.becomeFirstResponder()
    }
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-200)
      }
      
      textField.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(40)
        make.left.equalToSuperview().inset(20)
        make.right.equalToSuperview().inset(20)
        make.height.equalTo(70)
      }
      
      bottomView.snp.makeConstraints { (make) in
        make.left.right.equalTo(textField)
        make.top.equalTo(textField.snp.bottom)
        make.height.equalTo(1)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension NickNameViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}
