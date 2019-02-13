//
//  MainMatchViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import UICountingLabel

final class MainMatchViewController: UIViewController {
  private var isFirst = false
  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  private let bgImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "bgMatchingStart.png")
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private let countingLabel: UICountingLabel = {
    let label = UICountingLabel()
    label.font = UIFont.AppleSDGothicNeoBold(size: 21)
    label.textColor = .white
    label.numberOfLines = 0
    label.textAlignment = .center
    label.attributedFormatBlock = { value in
      let attributedString = NSMutableAttributedString(string: "누적동행 \(Int(value)) 건\n\n", attributes: [.font: UIFont.OTGulimH(size: 30),.foregroundColor: UIColor.white])
      attributedString.append(NSAttributedString(string: "여행자가 당신을 기다리고 있어요!", attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 21),.foregroundColor: UIColor.white]))
      return attributedString
    }
    label.method = UILabelCountingMethod.easeInOut
    return label 
  }()
  
  private let addMatchButton: UIButton = {
    let button = UIButton()
    button.setTitle("여행 등록", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoBold(size: 18)
    button.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.1529411765, blue: 0.3882352941, alpha: 1)
    button.layer.cornerRadius = 5
    return button
  }()
  
  let explainLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    let attributedString = NSMutableAttributedString(string: "정확한 여행 등록은 매칭 확률이 높아져요\n\n", attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 15),.foregroundColor: #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)])
    attributedString.append(NSAttributedString(string: "프로필을 통해 더 잘맞는 동행을 찾아보세요", attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 18),.foregroundColor: #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)]))
    label.attributedText = attributedString
    label.textAlignment = .center
    return label
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = bgImage
    
    bgImage.addSubview(addMatchButton)
    bgImage.addSubview(explainLabel)
    bgImage.addSubview(countingLabel)
    view.setNeedsUpdateConstraints()
    setNeedsStatusBarAppearanceUpdate()
    addMatchButton.rx.tap
      .debounce(0.3, scheduler: MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.navigationController?.pushViewController(MatchTypeViewController(), animated: true)
        }
    }.disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.backgroundColor = .clear
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isFirst{
      animationStart()
      isFirst = true
    }
  }
  
  private func animationStart(){
    AuthManager.instance
      .provider
      .request(.TotalMatchCount)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<Int>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .elements()
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {count in
          weakSelf.countingLabel.count(from: 0, to: CGFloat(integerLiteral: count))
        }
      }.disposed(by: disposeBag)
    
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      
      countingLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.centerY.equalToSuperview().inset(-120)
      }
      
      addMatchButton.snp.makeConstraints { (make) in
        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
        make.left.right.equalToSuperview().inset(11)
        make.height.equalTo(55)
      }
      
      explainLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.bottom.equalTo(addMatchButton.snp.top).inset(-31)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

