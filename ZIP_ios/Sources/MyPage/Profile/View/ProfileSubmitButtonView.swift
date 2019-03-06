//
//  ProfileSubmitButtonView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 25/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSubmitButtonView: UIView {
  let disposeBag = DisposeBag()
  
  enum Action{
    case deny
    case accept
    case apply
  }
  enum Status{
    case Default
    case Wait
    case Accept
  }
  
  private var didUpdateConstraint = false
  
  let statusSetting = BehaviorRelay<Status>(value: .Default)
  let buttonAction = PublishRelay<Action>()
  private let applyWaitButton: UIButton = {
    var button = UIButton()
    button.setTitle("동행신청", for: .normal)
    button.setTitle("상대응답에 대기중입니다.", for: .selected)
    button.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    button.layer.cornerRadius = 5
    return button
  }()
  
  private let denyButton: UIButton = {
    let button = UIButton()
    button.setTitle("거절", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.3165900409, green: 0.4789946079, blue: 0.8950387836, alpha: 1)
    return button
  }()
  
  private let acceptButton: UIButton = {
    let button = UIButton()
    button.setTitle("동행 수락", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.3657193482, green: 0.6326938868, blue: 0.9961630702, alpha: 1)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(applyWaitButton)
    addSubview(denyButton)
    addSubview(acceptButton)
    needsUpdateConstraints()
    bind()
  }
  
  private func bind(){
    statusSetting
      .bind(onNext: constraintChange)
      .disposed(by: disposeBag)
    
    Observable.merge(
      applyWaitButton.rx.tap
      .map{Action.apply}
      ,denyButton.rx.tap
        .map{Action.deny}
      ,acceptButton.rx.tap.map{Action.accept})
      .bind(to: buttonAction)
      .disposed(by: disposeBag)
    
  }
  
  func constraintChange(status: Status){
    switch status{
    case .Default:
      applyWaitButton.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
      applyWaitButton.snp.remakeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
      }
    case .Accept:
      applyWaitButton.snp.removeConstraints()
      denyButton.snp.remakeConstraints({ (make) in
        make.left.bottom.equalToSuperview().inset(10)
        make.width.equalToSuperview().dividedBy(3.5)
        make.height.equalToSuperview()
      })
      
      acceptButton.snp.makeConstraints { (make) in
        make.left.equalTo(denyButton.snp.right).offset(10)
        make.bottom.right.equalToSuperview().inset(10)
        make.height.equalTo(denyButton)
      }
      
    case .Wait:
      applyWaitButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      applyWaitButton.isSelected = true
    }
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      applyWaitButton.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
