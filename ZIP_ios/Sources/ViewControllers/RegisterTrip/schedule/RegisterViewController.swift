//
//  RegisterViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 30..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import LGButton
import RxSwift
import RxCocoa
import Moya
import TTTAttributedLabel
import NVActivityIndicatorView

class RegisterViewController: UIViewController, NVActivityIndicatorViewable{
  var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  let viewModel: RegisterTripViewModel = RegisterTripViewModel()
  private let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "bgMactingfin.png")
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "등록이\n완료되었어요!"
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = .KoreanSWGI1R(size: 25)
    label.textColor = .white
    return label
  }()
  
  private let typeLabel: UILabel = {
    let label = UILabel()
    label.text = "\t계획매칭"
    label.font = .AppleSDGothicNeoSemiBold(size: 22)
    label.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    return label
  }()
  
  private let centerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    return view
  }()
  
  let registerButton: LGButton = {
    let button = LGButton()
    button.titleString = "등록"
    button.titleFontName = "NotoSansKR-Medium"
    button.gradientStartColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    button.gradientEndColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 0.5)
    button.cornerRadius = 10
    button.shadowOffset = CGSize(width: 0, height: 2)
    button.shadowOpacity = 1
    button.shadowColor = .lightGray
    return button
  }()
  
  private let placeLabel: UILabel = {
    let label = UILabel()
    label.text = "장소"
    label.font = .AppleSDGothicNeoRegular(size: 20.4)
    label.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
    return label
  }()
  
  private let resultPlace: UILabel = {
    let label = UILabel()
    label.font = UIFont.AppleSDGothicNeoSemiBold(size: 20.4)
    return label
  }()
  
  private let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
    return view
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.text = "날짜"
    label.font = .AppleSDGothicNeoRegular(size: 20.4)
    label.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
    return label
  }()
  
  private let resultDataLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.AppleSDGothicNeoSemiBold(size: 20.4)
    label.textAlignment = .right
    label.numberOfLines = 0
    return label
  }()
  
  let strokeView: StrokeView = {
    let view = StrokeView()
    view.backgroundColor = .clear
    return view
  }()
  
  private let circle0: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.3568627451, blue: 0.9254901961, alpha: 1)
    view.layer.cornerRadius = 20
    view.clipsToBounds = true
    return view
  }()
  
  private let circle1: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.3568627451, blue: 0.9254901961, alpha: 1)
    view.layer.cornerRadius = 20
    view.clipsToBounds = true
    return view
  }()
  
  private let completeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonMatchingfin.png"), for: .normal)
    return button
  }()
  
  private lazy var lastChanceLabel: TTTAttributedLabel = {
    let label = TTTAttributedLabel(frame: .zero)
    let attstring = NSMutableAttributedString(string: "잘못 입력한 부분이 있나요?  ",
                                       attributes: [.font : UIFont.AppleSDGothicNeoRegular(size: 15)])
    attstring.append(NSAttributedString(string: "다시 입력하기", attributes: [.font: UIFont.AppleSDGothicNeoBold(size: 15)]))
    label.attributedText = attstring
    label.textColor = .black
    label.linkAttributes = [kCTForegroundColorAttributeName:#colorLiteral(red: 0.3294117647, green: 0.4274509804, blue: 0.8823529412, alpha: 1)]
    label.activeLinkAttributes = [kCTForegroundColorAttributeName:#colorLiteral(red: 0.3294117647, green: 0.4274509804, blue: 0.8823529412, alpha: 1)]
    label.inactiveLinkAttributes = [kCTForegroundColorAttributeName:#colorLiteral(red: 0.3294117647, green: 0.4274509804, blue: 0.8823529412, alpha: 1)]
    label.delegate = self
    let range = NSRange(location: 17, length: 7)
    label.addLink(to: URL(fileURLWithPath: ""), with: range)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = backImageView
    
    backImageView.addSubview(titleLabel)
    backImageView.addSubview(centerView)
    centerView.addSubview(typeLabel)
    centerView.addSubview(placeLabel)
    centerView.addSubview(resultPlace)
    centerView.addSubview(dividLine)
    centerView.addSubview(dateLabel)
    centerView.addSubview(resultDataLabel)
    centerView.addSubview(circle0)
    centerView.addSubview(circle1)
    centerView.addSubview(strokeView)
    centerView.addSubview(completeButton)
    centerView.addSubview(lastChanceLabel)
    self.navigationController?.navigationBar.topItem?.title = String()
    bind()
    
    view.setNeedsUpdateConstraints()
  }
  
  private func bind(){
    viewModel.outputs
      .dateString
      .bind(to: resultDataLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.outputs
      .placeName
      .bind(to: resultPlace.rx.text)
      .disposed(by: disposeBag)
    
    
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
      }
      
      centerView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(26)
        make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(34)
        make.top.equalTo(titleLabel.snp.bottom).offset(50)
      }
      
      typeLabel.snp.makeConstraints { (make) in
        make.left.top.right.equalToSuperview()
        make.height.equalTo(76)
      }
      
      placeLabel.snp.makeConstraints { (make) in
        make.top.equalTo(typeLabel.snp.bottom).offset(33)
        make.left.equalToSuperview().inset(30)
      }
      
      resultPlace.snp.makeConstraints { (make) in
        make.centerY.equalTo(placeLabel)
        make.right.equalToSuperview().inset(20)
      }
      
      dividLine.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(8)
        make.height.equalTo(2)
        make.top.equalTo(placeLabel.snp.bottom).offset(33)
      }
      
      dateLabel.snp.makeConstraints { (make) in
        make.left.equalTo(placeLabel)
        make.top.equalTo(dividLine.snp.bottom).offset(43)
      }
      
      resultDataLabel.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(20)
        make.centerY.equalTo(dateLabel)
      }

      circle0.snp.makeConstraints { (make) in
        make.centerY.equalTo(dateLabel.snp.bottom).offset(45)
        make.centerX.equalTo(self.centerView.snp.left)
        make.height.width.equalTo(40)
      }
      
      circle1.snp.makeConstraints { (make) in
        make.centerY.equalTo(circle0)
        make.centerX.equalTo(self.centerView.snp.right)
        make.height.width.equalTo(circle0)
      }
      
      strokeView.snp.makeConstraints { (make) in
        make.left.equalTo(circle0.snp.right).offset(10)
        make.right.equalTo(circle1.snp.left).offset(-10)
        make.centerY.equalTo(circle0)
        make.height.equalTo(4)
      }
      
      completeButton.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(circle0.snp.centerY).offset(41)
      }
      
      lastChanceLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(completeButton.snp.bottom).offset(10)
      }
      
      didUpdateConstraint = true

    }
    super.updateViewConstraints()
  }
}

extension RegisterViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
//    self.viewModel.scrollToFirst.accept(())
  }
}
