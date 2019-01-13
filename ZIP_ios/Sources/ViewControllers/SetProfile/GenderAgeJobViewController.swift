//
//  GenderViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa
import BetterSegmentedControl
import RxKeyboard
import SnapKit

final class GenderAgeJobViewController: UIViewController, ProfileCompletor{
  
  private let ageDatas = [[Int](10...80)]
  weak var backSubject: PublishSubject<Void>?
  weak var completeSubject: PublishSubject<Void>?
  weak var viewModel: ProfileViewModel?
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  private var constraint: Constraint?
  
  private let ageSelected = PublishRelay<Bool>()
  private var jobSelected = PublishRelay<Bool>()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    let attributedString = NSMutableAttributedString(string: "성별, 나이, 직업을 알려주세요.\n\n", attributes: [.font: UIFont.KoreanSWGI1R(size: 20), .foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)])
    attributedString.append(NSAttributedString(string: "개인정보는 프로필의 게시용으로만 사용됩니다.", attributes: [.font: UIFont.AppleSDGothicNeoLight(size: 14),.foregroundColor: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)]))
    label.numberOfLines = 3
    label.attributedText = attributedString
    return label
  }()
  
  private let genderLabel: UILabel = {
    let label = UILabel()
    label.text = "성별"
    label.font = .AppleSDGothicNeoMedium(size: 15)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  private let ageLabel: UILabel = {
    let label = UILabel()
    label.text = "나이"
    label.font = .AppleSDGothicNeoMedium(size: 15)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  private let jobLabel: UILabel = {
    let label = UILabel()
    label.text = "직업"
    label.font = .AppleSDGothicNeoMedium(size: 15)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  private let genderSegment: BetterSegmentedControl = {
    let segment = BetterSegmentedControl(frame: .zero, segments: [LabelSegment(text: "남자",
                                                                               normalBackgroundColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1),
                                                                               normalFont: .AppleSDGothicNeoSemiBold(size: 14),
                                                                               normalTextColor: #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1),
                                                                               selectedBackgroundColor: #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1),
                                                                               selectedFont: .AppleSDGothicNeoSemiBold(size: 14),
                                                                               selectedTextColor: .white),
                                                                  LabelSegment(text: "여자",   normalBackgroundColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1),
                                                                               normalFont: .AppleSDGothicNeoSemiBold(size: 14),
                                                                               normalTextColor: #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1),
                                                                               selectedBackgroundColor: #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1),
                                                                               selectedFont: .AppleSDGothicNeoSemiBold(size: 14),
                                                                               selectedTextColor: .white)])
    segment.options = [.cornerRadius(5)]
    return segment
  }()
  
  private lazy var agePickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
    return pickerView
  }()
  
  
  private let jobTextField: UITextField = {
    let field = UITextField()
    field.attributedPlaceholder = NSAttributedString(string: "ex) 디자이너, 승무원, 운동선수, 초등학교 교사", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 13)])
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    field.leftViewMode = .always
    field.layer.cornerRadius = 5
    field.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    field.layer.borderWidth = 1.2
    return field
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png"), for: .normal)
    return button
  }()

  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 21)
    button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    button.isEnabled = false
    button.layer.cornerRadius = 10
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(titleLabel)
    view.addSubview(genderLabel)
    view.addSubview(ageLabel)
    view.addSubview(jobLabel)
    view.addSubview(genderSegment)
    view.addSubview(agePickerView)
    view.addSubview(jobTextField)
    view.addSubview(backButton)
    view.addSubview(nextButton)
    viewModel?.saver.accept(.gender(value: "male"))
    
    hideKeyboardWhenTappedAround()
    view.setNeedsUpdateConstraints()
    
    rxBinder()
  }
  
  private func rxBinder(){
    
    Observable
      .combineLatest(ageSelected, jobSelected) {$0 && $1}
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return {result in
          weakSelf.nextButton.isEnabled = result
          weakSelf.nextButton.backgroundColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        }
      }.disposed(by: disposeBag)
    
    genderSegment.rx
      .controlEvent(UIControlEvents.valueChanged)
      .map{[unowned self] _ in return self.genderSegment.index}
      .subscribeNext(weak: self) { (weakSelf) -> ((UInt)) -> Void in
        return { idx in
          if idx == 0 {
            weakSelf.viewModel?.saver.accept(ProfileViewModel.ProfileType.gender(value: "male"))
          }else {
            weakSelf.viewModel?.saver.accept(ProfileViewModel.ProfileType.gender(value: "female"))
          }
        }
      }.disposed(by: disposeBag)
    
    
    agePickerView.rx
      .itemSelected
      .subscribeNext(weak: self, { (weakSelf) -> ((Int,Int)) -> Void in
        return { data in
          guard let label = weakSelf.agePickerView.view(forRow: data.0, forComponent: data.1) as? UILabel else {return}
          let attributeString = NSMutableAttributedString(string: "\(weakSelf.ageDatas[0][data.0])", attributes: [.font: UIFont.AppleSDGothicNeoRegular(size: 40.7)])
          attributeString.append(NSAttributedString(string: " 세", attributes: [.font: UIFont.AppleSDGothicNeoBold(size: 15)]))
          label.attributedText = attributeString
          label.textColor = .black
          weakSelf.viewModel?.saver.accept(.age(value: weakSelf.ageDatas[0][data.0]))
          weakSelf.ageSelected.accept(true)
        }
      }).disposed(by: disposeBag)
    
    jobTextField.rx
      .text
      .orEmpty
      .subscribeNext(weak: self) { (weakSelf) -> (String) -> Void in
        return {jobs in
          weakSelf.viewModel?.saver.accept(.job(value: jobs))
        }
      }.disposed(by: disposeBag)
    
    jobTextField.rx
      .text
      .orEmpty
      .map{$0.count}
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {count in
          weakSelf.jobSelected.accept(count > 0)
        }
    }.disposed(by: disposeBag)
    
    Observable.just(ageDatas)
      .bind(to: agePickerView.rx.items(adapter: PickerViewViewAdapter()))
      .disposed(by: disposeBag)
    
    guard let subject = completeSubject ,let back = backSubject else {return}
    
    nextButton.rx
      .tap
      .debounce(0.2, scheduler: MainScheduler.instance)
      .bind(to: subject)
      .disposed(by: disposeBag)
    
    backButton.rx
      .tap
      .bind(to: back)
      .disposed(by: disposeBag)
    
    RxKeyboard
      .instance
      .visibleHeight
      .drive(onNext: { [weak self] (height) in
        guard let weakSelf = self else {return}
        weakSelf.constraint?.update(inset: 69 - height)
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
          weakSelf.view.setNeedsLayout()
          weakSelf.view.layoutIfNeeded()
        }, completion: nil)
      }).disposed(by: disposeBag)
    
  }
  
  
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        constraint = make.top.equalTo(self.view.safeAreaLayoutGuide).inset(69).constraint
        make.left.equalToSuperview().inset(36)
      }
      
      genderLabel.snp.makeConstraints { (make) in
        make.left.equalTo(titleLabel)
        make.top.equalTo(titleLabel.snp.bottom).offset(30)
      }
      
      genderSegment.snp.makeConstraints { (make) in
        make.top.equalTo(genderLabel.snp.bottom).offset(5)
        make.left.equalTo(genderLabel)
        make.right.equalToSuperview().inset(36)
        make.height.equalTo(43)
      }
      
      ageLabel.snp.makeConstraints { (make) in
        make.left.equalTo(genderLabel)
        make.top.equalTo(genderSegment.snp.bottom).offset(50)
      }
      
      agePickerView.snp.makeConstraints { (make) in
        make.top.equalTo(ageLabel.snp.bottom).offset(-100)
        make.centerX.equalToSuperview()
        make.width.equalTo(100)
        make.height.equalTo(300)
      }
      
      jobLabel.snp.makeConstraints { (make) in
        make.left.equalTo(ageLabel)
        make.top.equalTo(ageLabel.snp.bottom).offset(100)
      }
      
      jobTextField.snp.makeConstraints { (make) in
        make.left.equalTo(jobLabel)
        make.top.equalTo(jobLabel.snp.bottom).offset(5)
        make.right.equalToSuperview().inset(36)
        make.height.equalTo(43)
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(10)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        make.width.height.equalTo(50)
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

final class PickerViewViewAdapter
  : NSObject
  , UIPickerViewDataSource
  , UIPickerViewDelegate
  , RxPickerViewDataSourceType
, SectionedViewDataSourceType {
  typealias Element = [[CustomStringConvertible]]
  private var items: [[CustomStringConvertible]] = []
  
  func model(at indexPath: IndexPath) throws -> Any {
    return items[indexPath.section][indexPath.row]
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return items.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    pickerView.subviews.forEach({
      $0.isHidden = $0.frame.height < 1.0
    })
    return items[component].count
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let label = UILabel()
    label.text = items[component][row].description
    label.textColor = #colorLiteral(red: 0.7725490196, green: 0.7725490196, blue: 0.7725490196, alpha: 1)
    label.font = .AppleSDGothicNeoRegular(size: 36.6)
    label.textAlignment = .center
    label.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
    return label
  }
  
  func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
    Binder(self) { (adapter, items) in
      adapter.items = items
      pickerView.reloadAllComponents()
      }.on(observedEvent)
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 80
  }
}
