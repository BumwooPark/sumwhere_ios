//
//  NickNameViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift

final class NickNameViewController: UIViewController, ProfileCompletor{
  var completeSubject: PublishSubject<Void>?
  
  var didUpdateConstraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "당신을 대표할\n닉네임을 입력해 주세요"
    label.font = .AppleSDGothicNeoMedium(size: 20)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    label.numberOfLines = 2
    return label
  }()
  
  private lazy var textField: UITextField = {
    let field = UITextField()
    field.returnKeyType = .done
    field.delegate = self
    field.font = .AppleSDGothicNeoMedium(size: 20)
    field.attributedPlaceholder = NSAttributedString(string: "닉네임 입력", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 20)])
    return field
  }()
  
  private let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 21)
    button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    button.isEnabled = false
    return button
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    scrollView.contentSize = UIScreen.main.bounds.size
    return scrollView
  }()
  
  private let contentView: UIView = {
    let contentView = UIView()
    return contentView
  }()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {[weak self] in
      self?.completeSubject?.onNext(())
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(textField)
    contentView.addSubview(bottomView)
    contentView.addSubview(nextButton)
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
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      contentView.snp.makeConstraints { (make) in
        make.height.width.equalTo(self.view)
        make.leading.trailing.top.bottom.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(41)
        make.centerY.equalToSuperview().inset(-100)
      }
      
      textField.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(40)
        make.left.equalTo(titleLabel)
        make.right.equalToSuperview().inset(41)
        
        make.height.equalTo(70)
      }
      
      bottomView.snp.makeConstraints { (make) in
        make.left.right.equalTo(textField)
        make.top.equalTo(textField.snp.bottom)
        make.height.equalTo(1)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(61)
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
