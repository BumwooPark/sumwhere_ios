//
//  GenderViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift

final class GenderViewController: UIViewController, ProfileCompletor{
  
  weak var backSubject: PublishSubject<Void>?
  weak var completeSubject: PublishSubject<Void>?
  weak var viewModel: ProfileViewModel?
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png"), for: .normal)
    return button
  }()

  private let girlButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "group4.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "group3.png"), for: .selected)
    return button
  }()
  
  private let boyButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "group.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "group2.png"), for: .selected)
    return button
  }()
  
  
  private let girlLabel: UILabel = {
    let label = UILabel()
    label.text = "여자"
    label.font = .AppleSDGothicNeoMedium(size: 17)
    label.textColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    return label
  }()
  
  private let boyLabel: UILabel = {
    let label = UILabel()
    label.text = "남자"
    label.font = .AppleSDGothicNeoMedium(size: 17)
    label.textColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    return label
  }()
  
  private lazy var girlStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [girlButton,girlLabel])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var boyStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [boyButton,boyLabel])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [boyStackView,girlStackView])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    return stackView
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
    let view = UIScrollView()
    view.contentSize = UIScreen.main.bounds.size
    view.alwaysBounceVertical = true
    return view
  }()
  
  private let contentView = UIView()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "성별을 선택해주세요"
    label.font = .AppleSDGothicNeoMedium(size: 20)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(backButton)
    contentView.addSubview(titleLabel)
    contentView.addSubview(stackView)
    contentView.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
    
    rxBinder()
  }
  
  private func rxBinder(){
    girlButton.rx
      .tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return { _ in
          weakSelf.girlButton.isSelected = true
          weakSelf.boyButton.isSelected = false
          weakSelf.girlLabel.textColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
          weakSelf.boyLabel.textColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
          weakSelf.viewModel?.saver.onNext(.gender(value: "female"))
          weakSelf.nextButton.isEnabled = true
          weakSelf.nextButton.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
        }
      }.disposed(by: disposeBag)
    
    boyButton.rx
      .tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return { _ in
          weakSelf.boyButton.isSelected = true
          weakSelf.girlButton.isSelected = false
          weakSelf.girlLabel.textColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
          weakSelf.boyLabel.textColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
          weakSelf.viewModel?.saver.onNext(.gender(value: "male"))
          weakSelf.nextButton.isEnabled = true
          weakSelf.nextButton.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
        }
      }.disposed(by: disposeBag)
    
    
    guard let subject = completeSubject ,let back = backSubject else {return}
    
    nextButton.rx
      .tap
      .bind(to: subject)
      .disposed(by: disposeBag)
    
    backButton.rx
      .tap
      .bind(to: back)
      .disposed(by: disposeBag)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      contentView.snp.makeConstraints { (make) in
        make.height.width.equalTo(self.view)
        make.left.right.bottom.top.equalToSuperview()
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalTo(self.view).inset(10)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        make.height.width.equalTo(50)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview().inset(-200)
        make.left.equalToSuperview().inset(41)
      }
      
      stackView.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.left.right.equalToSuperview().inset(91)
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
