//
//  RegisterViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 30..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import LGButton
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController{
  
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  let viewController: CreateTravelViewController
  
  let infoLabel: UILabel = {
    let label = UILabel()
    label.text = "위와 같은 내용으로 등록하시겠습니까?"
    label.font = UIFont.BMJUA(size: 18)
    return label
  }()
  
  let registerButton: LGButton = {
    let button = LGButton()
    button.titleString = "등록"
    button.titleFontName = "BMJUAOTF"
    button.gradientStartColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    button.gradientEndColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 0.5)
    button.cornerRadius = 10
    button.shadowOffset = CGSize(width: 0, height: 2)
    button.shadowOpacity = 1
    button.shadowColor = .lightGray
    return button
  }()
  
  let cancelButton: LGButton = {
    let button = LGButton()
    button.titleString = "취소"
    button.titleFontName = "BMJUAOTF"
    button.gradientStartColor = #colorLiteral(red: 0.7803921569, green: 0.3949215683, blue: 0.3463978405, alpha: 1)
    button.gradientEndColor = #colorLiteral(red: 0.7803921569, green: 0.4357580746, blue: 0.4270587234, alpha: 0.5)
    button.cornerRadius = 10
    button.shadowOffset = CGSize(width: 0, height: 2)
    button.shadowOpacity = 1
    button.shadowColor = .lightGray
    return button
  }()
  
  init(viewController: UIViewController) {
    self.viewController = viewController as! CreateTravelViewController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(registerButton)
    view.addSubview(cancelButton)
    view.addSubview(infoLabel)
    
    registerButton.rx.tapGesture()
      .when(.ended)
      .debounce(1, scheduler: MainScheduler.instance)
      .map {_ in return ()}
      .bind(onNext: register)
      .disposed(by: disposeBag)
    
    cancelButton.rx
      .tapGesture()
      .when(.ended)
      .subscribe(onNext: {[weak self] (_) in
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
    
    view.setNeedsUpdateConstraints()
  }
  
  func register(){
    viewController
      .viewModel
      .createTravel().subscribe(onNext: { (model) in
      log.info(model)
    }).disposed(by: disposeBag)
  }
  
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      didUpdateConstraint = true
      
      infoLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.bottom.equalTo(registerButton.snp.top).offset(-40)
      }
      
      registerButton.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.height.equalTo(50)
        make.width.equalTo(200)
      }
      
      cancelButton.snp.makeConstraints { (make) in
        make.top.equalTo(registerButton.snp.bottom).offset(30)
        make.centerX.equalToSuperview()
        make.height.width.equalTo(registerButton)
      }
    }
    super.updateViewConstraints()
  }
}
