//
//  BottomPannelViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift

final class BottomPannelViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  
  private let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  private let stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.distribution = .fillEqually
    view.alignment = UIStackView.Alignment.leading
    return view
  }()
  
  private let reportButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "reporticon.png"), for: .normal)
    button.setTitle("신고하기", for: .normal)
    button.titleLabel?.font = UIFont.AppleSDGothicNeoSemiBold(size: 18)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
    return button
  }()
  
  private let exitButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "exiticon.png"), for: .normal)
    button.setTitle("대화방 나가기", for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.titleLabel?.font = UIFont.AppleSDGothicNeoSemiBold(size: 18)
    button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
    return button
  }()
  
  private let cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIView.animate(withDuration: 0.5) {[weak self] in
      self?.presentingViewController?.view.alpha = 0.65
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIView.animate(withDuration: 0.5) {[weak self] in
      self?.presentingViewController?.view.alpha = 1
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    view.addSubview(bottomView)
    bottomView.addSubview(stackView)
    stackView.addArrangedSubview(reportButton)
    stackView.addArrangedSubview(exitButton)
    bottomView.addSubview(cancelButton)
    view.setNeedsUpdateConstraints()
    
    cancelButton.rx.tap
      .bind(onNext: dismiss)
      .disposed(by: disposeBag)
    
    view.rx.tapGesture()
      .when(.ended)
      .subscribeNext(weak: self) { (weakSelf) -> (UITapGestureRecognizer) -> Void in
        return {_ in
          weakSelf.dismiss()
        }
    }.disposed(by: disposeBag)
    
  }
  
  func dismiss(){
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      
      bottomView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview()
        make.bottom.equalToSuperview()
        make.height.equalToSuperview().dividedBy(3)
      }
      
      stackView.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(10)
        make.right.top.equalToSuperview()
        make.bottom.equalTo(cancelButton.snp.top).inset(-20)
      }
      
      cancelButton.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview().inset(8)
        make.height.equalTo(49)
        
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
}
