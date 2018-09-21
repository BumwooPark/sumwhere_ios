//
//  GenderViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift

final class GenderViewController: UIViewController, ProfileCompletor{
  weak var completeSubject: PublishSubject<Void>?
  weak var viewModel: SetProfileViewModel?
  var didUpdateConstraint = false
  
  private let girlButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "group3").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    return button
  }()
  
  private let boyButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "group").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
    return button
  }()
  
  private lazy var girlStackView: UIStackView = {
    let label = UILabel()
    label.text = "여자"
    let stackView = UIStackView(arrangedSubviews: [girlButton,label])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var boyStackView: UIStackView = {
    let label = UILabel()
    label.text = "남자"
    let stackView = UIStackView(arrangedSubviews: [boyButton,label])
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
    contentView.addSubview(titleLabel)
    contentView.addSubview(stackView)
    contentView.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
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
