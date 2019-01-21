//
//  MatchSelectGenderViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MatchSelectGenderViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "함께할 동행자의\n성별을 선택해주세요."
    label.numberOfLines = 0
    label.font = .AppleSDGothicNeoSemiBold(size: 23)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  private let manButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonGenderManFin.png"), for: .highlighted)
    button.setImage(#imageLiteral(resourceName: "buttonGenderMan.png"), for: .normal)
    return button
  }()
  
  private let girlButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonGenderWomanFin.png"), for: .highlighted)
    button.setImage(#imageLiteral(resourceName: "buttonGenderWoman.png"), for: .normal)
    return button
  }()
  
  private let nobodyButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonGenderFin.png"), for: .highlighted)
    button.setImage(#imageLiteral(resourceName: "buttonGender.png"), for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.9679030776, green: 0.9724431634, blue: 0.9897400737, alpha: 1)
    view.addSubview(titleLabel)
    view.addSubview(manButton)
    view.addSubview(girlButton)
    view.addSubview(nobodyButton)
    self.navigationController?.navigationBar.topItem?.title = String()
    view.setNeedsUpdateConstraints()
    
    Observable.merge([manButton.rx.tap.asObservable(),girlButton.rx.tap.asObservable(),nobodyButton.rx.tap.asObservable()])
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.navigationController?.pushViewController(CreateTripViewController(), animated: true)
        }
      }.disposed(by: disposeBag)
    
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(37)
        make.top.equalToSuperview().inset(82)
      }
      
      manButton.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(44)
        make.left.right.equalToSuperview().inset(28)
        make.height.equalTo(128)
      }
      
      girlButton.snp.makeConstraints { (make) in
        make.top.equalTo(manButton.snp.bottom).offset(12)
        make.left.right.height.equalTo(manButton)
      }
      
      nobodyButton.snp.makeConstraints { (make) in
        make.top.equalTo(girlButton.snp.bottom).offset(12)
        make.left.right.height.equalTo(manButton)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
