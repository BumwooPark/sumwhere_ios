//
//  MatchPopUpViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 03/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

final class MatchPopUpViewController: UIViewController{
  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  var buttonAction: (()-> Void)?
  
  var item: Int? {
    didSet{
      let attributedString = NSAttributedString(string: "무료 횟수: \(item ?? 0)회",
                                                attributes: [.foregroundColor: #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1),
                                                             .font: UIFont.AppleSDGothicNeoSemiBold(size: 13.2),
                                                             .underlineStyle: 1,
                                                             .underlineColor:#colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)])
      keyLeftLabel.attributedText = attributedString
    }
  }
  private let contentView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    view.backgroundColor = .white
    return view
  }()
  
  private let popUpDismiss: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "popupExit.png"), for: .normal)
    return button
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "bgOk.png"))
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "동행을 시작해볼까요?"
    label.font = UIFont.AppleSDGothicNeoBold(size: 17)
    label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    return label
  }()
  
  private let keyLeftLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let detailTextLabel: UILabel = {
    let label = UILabel()
    label.text = "무료 횟수가 다 소진되면\n자동으로 키가 소모됩니다."
    label.font = .AppleSDGothicNeoMedium(size: 14)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
    return label
  }()
  
  private let submitButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.3173762262, green: 0.4791930914, blue: 0.8946794868, alpha: 1)
    button.setTitle("동행 신청", for: .normal)
    button.layer.cornerRadius = 22
    return button
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIView.animate(withDuration: 0.5) {[weak self] in
      self?.presentingViewController?.view.alpha = 0.6
    }  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIView.animate(withDuration: 0.5) {[weak self] in
      self?.presentingViewController?.view.alpha = 1
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    view.addSubview(contentView)
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(keyLeftLabel)
    contentView.addSubview(detailTextLabel)
    contentView.addSubview(popUpDismiss)
    contentView.addSubview(submitButton)
    
    popUpDismiss.rx
      .tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.dismiss(animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    submitButton.rx.tap
      .bind(onNext: applyAfter)
      .disposed(by: disposeBag)
    
    view.setNeedsUpdateConstraints()
  }
  
  func applyAfter(){
    guard let ownModel = tripRegisterContainer.resolve(TripModel.self, name: "own"),
      let targetModel = tripRegisterContainer.resolve(Trip.self,name: "target") else {return}
    let request = MatchRequstModel(fromMatchId: ownModel.trip.id, toMatchId: targetModel.id, accepted: false)
    AuthManager.instance.provider.request(.MatchRequest(model: request))
      .filterSuccessfulStatusCodes()
      .subscribe(onSuccess: { (response) in
        log.info(response)
      }, onError: { (error) in
        log.error(error)
      }).disposed(by: self.disposeBag)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      contentView.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.width.equalToSuperview().dividedBy(1.5)
        make.height.equalToSuperview().dividedBy(2)
      }
      
      popUpDismiss.snp.makeConstraints { (make) in
        make.left.top.equalToSuperview().inset(21)
        make.width.height.equalTo(20)
      }

      imageView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-90)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(imageView.snp.bottom).offset(18)
      }
      
      keyLeftLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(titleLabel.snp.bottom).offset(5)
      }
      
      detailTextLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(keyLeftLabel.snp.bottom).offset(15)
      }
      
      submitButton.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.bottom.equalToSuperview().inset(30)
        make.height.equalTo(44)
        make.width.equalToSuperview().dividedBy(2)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
