//
//  ChangeConceptViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 04/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

class ChangeConceptViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  var trip: Trip
  var didUpdateConstraint = false
  var completed: ((TripModel) -> ())?
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "이번 여행의 컨샙을\n정해볼까요?"
    label.numberOfLines = 0
    label.font = UIFont.KoreanSWGI1R(size: 26)
    label.textColor = .black
    return label
  }()
  
  private let cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "popupDismiss"), for: .normal)
    return button
  }()
  
  private let textView: UITextField = {
    let text = UITextField()
    text.placeholder = "명소 모두 정복하기:)"
    text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    text.leftViewMode = .always
    text.font = .AppleSDGothicNeoMedium(size: 16)
    text.layer.cornerRadius = 4
    text.layer.borderWidth = 1
    text.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
    text.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    text.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    return text
  }()
  
  private let completeButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoSemiBold(size: 22.8)
    button.setTitle("확인", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    button.layer.cornerRadius = 11
    button.layer.masksToBounds = true
    button.isEnabled = false
    return button
  }()
  
  init(trip: Trip) {
    self.trip = trip
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(cancelButton)
    view.addSubview(titleLabel)
    view.addSubview(textView)
    view.addSubview(completeButton)
    view.setNeedsUpdateConstraints()
    let text = textView.rx.text.orEmpty.share()
    
    text
      .map{$0.count > 2}
      .subscribeNext(weak: self, { (weakSelf) -> (Bool) -> Void in
        return { result in
          weakSelf.completeButton.isEnabled = result
          weakSelf.completeButton.backgroundColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        }
      })
      .disposed(by: disposeBag)

    completeButton.rx.tap
      .map{[unowned self]_ in self.textView.text}
      .unwrap()
      .bind(onNext: Update)
      .disposed(by: disposeBag)
    
    cancelButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.dismiss(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
  }
  
  func Update(concept: String){
    AuthManager.instance.provider.request(.UpdateTrip(tripId: trip.id, data: ["concept": concept]))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<TripModel>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (TripModel) -> Void in
        return { model in
          weakSelf.completed?(model)
          weakSelf.dismiss(animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
  }
  
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      cancelButton.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(30)
        make.right.equalToSuperview().inset(20)
        make.height.width.equalTo(50)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(26)
        make.top.equalToSuperview().inset(87)
      }
      
      textView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(26)
        make.top.equalTo(titleLabel.snp.bottom).offset(37)
        make.height.equalTo(52)
      }
      
      completeButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        make.height.equalTo(50)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

