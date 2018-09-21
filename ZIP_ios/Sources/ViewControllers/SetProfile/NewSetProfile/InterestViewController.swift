//
//  InterestViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift

final class InterestViewController: UIViewController, ProfileCompletor{
  
  private var didUpdateContraint = false
  weak var viewModel: SetProfileViewModel?
  weak var completeSubject: PublishSubject<Void>?
  private let titleLabel: UILabel = {
    let attributeString = NSMutableAttributedString(string: "당신의 여행스타일과\n그에 맞는 관심사를 선택해주세요\n",
                                                    attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 20),
                                                                 .foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1) ])
    attributeString.append(NSAttributedString(string: "최소 세개까지 선택이 가능합니다.",
                                              attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 14),
                                                           .foregroundColor: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)]))
    
    let label = UILabel()
    label.attributedText = attributeString
    label.numberOfLines = 3
    return label
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 21)
    button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    button.isEnabled = false
    return button
  }()
  
  
  override func viewDidLoad(){
    super.viewDidLoad()
    view.addSubview(titleLabel)
    view.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateContraint{
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(79)
        make.left.equalToSuperview().inset(36)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(61)
      }
      
      didUpdateContraint = true
    }
    
    super.updateViewConstraints()
  }
  
  
}
