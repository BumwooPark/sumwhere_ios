//
//  NickNameViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift
import Moya

final class NickNameViewController: UIViewController, ProfileCompletor{
  
  private let disposeBag = DisposeBag()
  
  weak var backSubject: PublishSubject<Void>?
  weak var viewModel: ProfileViewModel?
  weak var completeSubject: PublishSubject<Void>?
  
  enum nicknameStatus{
    case success
    case fail
    
    var color: UIColor{
      switch self{
      case .success:
        return #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
      case .fail:
        return #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
      }
    }
    
    var description: String{
      switch self{
      case .fail:
        return "이미 사용중인 닉네임이에요."
      case .success:
        return "짝짝짝! 사용가능한 닉네임이에요."
      }
    }
  }
  
  var didUpdateConstraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "당신을 대표할\n닉네임을 입력해 주세요."
    label.font = .KoreanSWGI1R(size: 20)
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
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoLight(size: 14)
    return label
  }()
  
  private let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    return view
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 21)
    button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    button.layer.cornerRadius = 10
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(textField)
    contentView.addSubview(bottomView)
    contentView.addSubview(nextButton)
    contentView.addSubview(descriptionLabel)
    rxbind()
    view.setNeedsUpdateConstraints()
    hideKeyboardWhenTappedAround()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  private func rxbind(){
    
    guard let viewModel = viewModel else {return}
    
    let textObserver = textField.rx.text
      .orEmpty
      .map{$0.replacingOccurrences(of: " ", with: "")}
      .share()
    
    textObserver
      .bind(to: textField.rx.text)
      .disposed(by: disposeBag)
    
    textObserver
      .subscribeNext(weak: self) { (weakSelf) -> (String) -> Void in
      return {name in
        weakSelf.viewModel?.saver.accept(.nickname(value: name))
      }
    }.disposed(by: disposeBag)
    
    textObserver
      .bind(to: viewModel.profileSubject)
      .disposed(by: disposeBag)
    
    textObserver
      .filter{$0.count <= 2}
      .subscribeNext(weak: self) { (weakSelf) -> (String) -> Void in
        return { _ in
          weakSelf.descriptionLabel.text = String()
          weakSelf.bottomView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
          weakSelf.nextButton.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
          weakSelf.nextButton.isEnabled = false
        }
      }.disposed(by: disposeBag)

    viewModel.profileResult
      .subscribe(weak: self) { (weakSelf) -> (Event<ResultModel<Bool>>) -> Void in
        return {event in
          switch event{
          case .next(let element):
            guard let result = element.result else {return}
            weakSelf.descriptionLabel.text = result ? nicknameStatus.success.description : nicknameStatus.fail.description
            weakSelf.descriptionLabel.textColor = result ? nicknameStatus.success.color : nicknameStatus.fail.color
            weakSelf.bottomView.backgroundColor = result ? nicknameStatus.success.color : nicknameStatus.fail.color
            weakSelf.nextButton.backgroundColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            weakSelf.nextButton.isEnabled = result
          case .error(let error):
            guard let err = error as? MoyaError else {return}
            err.GalMalErrorHandler()
          case .completed:
            break
          }
        }
    }.disposed(by: disposeBag)
    
    guard let subject = completeSubject else {return}
    nextButton.rx
      .tap
      .debounce(0.2, scheduler: MainScheduler.instance)
      .bind(to: subject)
      .disposed(by: disposeBag)
  }
 
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
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
        make.left.equalToSuperview().inset(37)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(81)
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
      
      descriptionLabel.snp.makeConstraints { (make) in
        make.left.equalTo(bottomView).inset(2)
        make.top.equalTo(bottomView.snp.bottom).offset(8)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(11)
        make.height.equalTo(56)
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
