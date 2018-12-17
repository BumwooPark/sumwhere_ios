//
//  SearchPasswordViewController.swift
//  ZIP_ios
//
//  Created by Parbumwoo on 17/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import SkyFloatingLabelTextField

final class SearchPasswordViewController: UIViewController {
  
  private var didUpdateConstraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .KoreanSWGI1R(size: 23)
    label.text = "비밀번호를 잊으셨나요?"
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  private let detailLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호를 재설정하기 위해\nSumwhere에 가입한 이메일을 입력해주세요."
    label.font = .AppleSDGothicNeoLight(size: 14)
    label.numberOfLines = 0
    label.textColor = .black
    return label
  }()
  
  private let summitButton: UIButton = {
    let button = UIButton()
    button.setTitle("확인", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    button.layer.cornerRadius = 10
    return button
  }()
  
  private let emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "이메일 주소"
    field.lineColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    field.placeholderFont = .AppleSDGothicNeoMedium(size: 16)
    field.font = .AppleSDGothicNeoMedium(size: 16)
    return field
  }()
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = String()
    
    view.addSubview(titleLabel)
    view.addSubview(detailLabel)
    view.addSubview(summitButton)
    view.addSubview(emailField)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(37)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(70)
      }
      
      detailLabel.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(19)
        make.left.equalTo(titleLabel)
      }
      
      emailField.snp.makeConstraints { (make) in
        make.top.equalTo(detailLabel.snp.bottom).offset(40)
        make.left.right.equalToSuperview().inset(37)
        make.height.equalTo(40)
      }
      
      summitButton.snp.makeConstraints { (make) in
        make.left.right.equalTo(emailField)
        make.top.equalTo(emailField.snp.bottom).offset(42)
        make.height.equalTo(55)
      }
      
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
