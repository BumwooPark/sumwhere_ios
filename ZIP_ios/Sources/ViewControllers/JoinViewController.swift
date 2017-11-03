//
//  JoinViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import Hero
import SkyFloatingLabelTextField

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

class JoinViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  
  let backImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "bare-1985858_1920"))
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let emailField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "이메일 주소"
    return field
  }()
  
  let nicknameField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "닉네임"
    return field
  }()
  
  let passwordField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "비밀번호"
    field.isSecureTextEntry = true
    return field
  }()
  
  let passwordConfField: SkyFloatingLabelTextField = {
    let field = SkyFloatingLabelTextField()
    field.placeholder = "비밀번호 확인"
    return field
  }()
  
  let joinButton: UIButton = {
    let button = UIButton()
    button.setTitle("가입하기", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    
    self.view.addSubview(backImageView)
    self.view.addSubview(emailField)
    self.view.addSubview(nicknameField)
    self.view.addSubview(passwordField)
    self.view.addSubview(passwordConfField)
    self.view.addSubview(joinButton)
    
    emailField.heroID = "emailField"
    passwordField.heroID = "passwordField"
    backImageView.heroID = "backImageView"
    
    //    self.view.heroModifiers = [.fade]
    
    addConstraint()
    
    joinButton.rx.controlEvent(.touchUpInside)
      .subscribe {[weak self] (_) in
        self?.presentingViewController?.dismiss(animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    
    self.view.heroID = "joinview"
    isHeroEnabled = true
    self.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
  }
  
  private func addConstraint(){
    
    backImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    emailField.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(50)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().dividedBy(1.5)
    }
    
    nicknameField.snp.makeConstraints { (make) in
      make.top.equalTo(emailField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(emailField)
    }
    
    passwordField.snp.makeConstraints { (make) in
      make.top.equalTo(nicknameField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(nicknameField)
    }
    
    passwordConfField.snp.makeConstraints { (make) in
      make.top.equalTo(passwordField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(passwordField)
    }
    
    joinButton.snp.makeConstraints { (make) in
      make.top.equalTo(passwordConfField.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
      make.width.equalTo(passwordConfField)
    }
  }
}

