//
//  ChangeGenderViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 02/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift

class ChangeGenderViewController: UIViewController{
  
  
  var completed: ((TripModel) -> ())?
  var trip: Trip
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  
  private let cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "popupDismiss"), for: .normal)
    return button
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "함께할 동행자의\n성별을 선택해주세요."
    label.numberOfLines = 0
    label.font = .AppleSDGothicNeoSemiBold(size: 23)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  private let maleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonGenderMan.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "buttonGenderManFin.png"), for: .highlighted)
    return button
  }()
  
  private let femaleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonGenderWoman.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "buttonGenderWomanFin.png"), for: .highlighted)
    return button
  }()
  
  private let nobodyButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonGender.png"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "buttonGenderFin.png"), for: .highlighted)
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
    view.addSubview(femaleButton)
    view.addSubview(maleButton)
    view.addSubview(nobodyButton)
    
    cancelButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.dismiss(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
    
    
    Observable
      .merge([maleButton.rx.tap.map{0},femaleButton.rx.tap.map{1},nobodyButton.rx.tap.map{2}])
      .map { (result) -> String in
        switch result {
        case 0:
          return "MALE"
        case 1:
          return "FEMALE"
        case 2:
          return "NONE"
        default:
          return ""
        }
      }.bind(onNext: Update)
      .disposed(by: disposeBag)

    view.setNeedsUpdateConstraints()
  }
  
  func Update(gender: String){
    self.trip.genderType = gender
    
    AuthManager.instance.provider.request(.UpdateTrip(tripId: trip.id, data: ["genderType": gender]))
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
        make.left.equalToSuperview().inset(37)
        make.top.equalToSuperview().inset(82)
      }
      
      maleButton.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(28)
        make.top.equalTo(titleLabel.snp.bottom).offset(44)
        make.height.equalTo(128)
      }
      
      femaleButton.snp.makeConstraints { (make) in
        make.height.left.right.equalTo(maleButton)
        make.top.equalTo(maleButton.snp.bottom).offset(12)
      }
      
      nobodyButton.snp.makeConstraints { (make) in
        make.height.left.right.equalTo(maleButton)
        make.top.equalTo(femaleButton.snp.bottom).offset(12)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}


