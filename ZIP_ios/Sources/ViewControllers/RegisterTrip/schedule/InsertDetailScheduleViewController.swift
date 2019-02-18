//
//  InsertDetailScheduleViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 12/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa
import Kingfisher

class InsertDetailScheduleViewController: UIViewController{
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  let viewModel = DetailScheduleViewModel()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = "방문할 세부 지역과\n무엇을 할지 정해볼까요?"
    label.textColor = .white
    label.font = UIFont.AppleSDGothicNeoBold(size: 24)
    return label
  }()
  
  private let currentRegionButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "iconPreocation.png"), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.titleLabel?.font = .AppleSDGothicNeoSemiBold(size: 12.9)
    button.isEnabled = false
    return button
  }()
  
  private let detailRegionButton: UIButton = {
    let button = UIButton()
    button.setTitle("세부 지역", for: .normal)
    button.setImage(#imageLiteral(resourceName: "detailLocation.png"), for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 12.9)
    button.isEnabled = false
    return button
  }()
  
  private let detailConceptButton: UIButton = {
    let button = UIButton()
    button.setTitle("활동 및 컨셉", for: .normal)
    button.setImage(#imageLiteral(resourceName: "iconActive.png"), for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 12.9)
    button.isEnabled = false
    return button
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.shadowOffset = CGSize(width: 0, height: 5)
    view.layer.shadowRadius = 10
    view.layer.shadowOpacity = 1
    view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    return view
  }()
  
  private let imageView: UIImageView = {
    var view = UIImageView()
    view.kf.indicatorType = .activity
    view.contentMode = .scaleAspectFill
    return view
  }()
  
  private let detailRegionField: UITextFieldPadding = {
    let textField = UITextFieldPadding()
    textField.placeholder = "ex) 카오산 로드"
    textField.layer.cornerRadius = 2.7
    textField.layer.borderWidth = 0.7
    textField.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    textField.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
    textField.font = .AppleSDGothicNeoRegular(size: 12.4)
    return textField
  }()
  
  private let activityField: UITextFieldPadding = {
    let textField = UITextFieldPadding(padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
    textField.placeholder = "ex)  카오산 로드에서 맥도날드 앞에서 사진을 찍고싶어요!"
    textField.textAlignment = .left
    textField.contentVerticalAlignment = .top
    textField.layer.cornerRadius = 2.7
    textField.layer.borderWidth = 0.7
    textField.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    textField.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
    textField.font = .AppleSDGothicNeoRegular(size: 12.4)
    return textField
  }()
  
  private let completeButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoSemiBold(size: 22.8)
    button.setTitle("다음", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    button.layer.cornerRadius = 11
    button.layer.masksToBounds = true
    button.isEnabled = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.topItem?.title = String()
    view.backgroundColor = .white
    view.addSubview(imageView)
    view.addSubview(contentView)
    view.addSubview(completeButton)
    imageView.addSubview(titleLabel)
    imageView.addSubview(currentRegionButton)
    contentView.addSubview(detailRegionButton)
    contentView.addSubview(detailRegionField)
    contentView.addSubview(detailConceptButton)
    contentView.addSubview(activityField)
    
    view.setNeedsUpdateConstraints()
    bind()
  }
  
  private func bind(){
    activityField.rx.text.orEmpty
      .bind(onNext: viewModel.inputs.activityTextUpdater)
      .disposed(by: disposeBag)
    
    detailRegionField.rx.text.orEmpty
      .bind(onNext: viewModel.inputs.detailRegionTextUpdater)
      .disposed(by: disposeBag)
    
    viewModel.outputs.imageData
      .subscribeNext(weak: self) { (weakSelf) -> (String) -> Void in
        return {url in
          let processor = BlendImageProcessor(blendMode: .darken, alpha: 1.0, backgroundColor: .lightGray)
          weakSelf.imageView.kf.setImage(with: URL(string: url.addSumwhereImageURL()), options: [.processor(processor),.transition(.fade(0.2)),.cacheOriginalImage])
        }
      }.disposed(by: disposeBag)
    
    viewModel.outputs.iskeyBoardShow
      .observeOn(MainScheduler.asyncInstance)
      .bind(onNext: topImageViewAdjust)
      .disposed(by: disposeBag)
    
    viewModel.outputs.isSuccess
      .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
        return {result in
          log.info(result)
          weakSelf.completeButton.isEnabled = result
          weakSelf.completeButton.backgroundColor = result ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        }
    }.disposed(by: disposeBag)
    
    viewModel.outputs.countryPlace
      .bind(to: currentRegionButton.rx.title())
      .disposed(by: disposeBag)
    
    completeButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return { _ in
          weakSelf.navigationController?.pushViewController(RegisterViewController(), animated: true)
        }
      }.disposed(by: disposeBag)
  }
  
  func topImageViewAdjust(result: Bool){
    if result {
      self.imageView.snp.remakeConstraints({ (make) in
        make.left.right.top.equalToSuperview()
        make.height.equalTo(100)
      })
    }else {
      imageView.snp.remakeConstraints({ (make) in
        make.left.right.top.equalToSuperview()
        make.height.equalTo(254)
      })
    }
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
      [unowned self] in
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
        make.left.right.top.equalToSuperview()
        make.height.equalTo(254)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(32)
        make.top.equalToSuperview().inset(73)
      }
      
      currentRegionButton.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(18)
        make.left.equalTo(titleLabel)
      }
      
      contentView.snp.makeConstraints { (make) in
        make.top.equalTo(imageView.snp.bottom).inset(50)
        make.left.right.equalToSuperview().inset(27)
        make.bottom.equalTo(completeButton.snp.top).inset(-34)
      }
      
      detailRegionButton.snp.makeConstraints { (make) in
        make.left.top.equalToSuperview().inset(31)
        make.height.equalTo(16)
      }
      
      detailRegionField.snp.makeConstraints { (make) in
        make.left.equalTo(detailRegionButton)
        make.top.equalTo(detailRegionButton.snp.bottom).offset(8)
        make.height.equalTo(34)
        make.right.equalToSuperview().inset(25)
      }
      
      detailConceptButton.snp.makeConstraints { (make) in
        make.left.equalTo(detailRegionField)
        make.top.equalTo(detailRegionField.snp.bottom).offset(31)
        make.height.equalTo(16)
      }
      
      activityField.snp.makeConstraints { (make) in
        make.left.equalTo(detailConceptButton)
        make.right.equalTo(detailRegionField)
        make.top.equalTo(detailConceptButton.snp.bottom).offset(8)
        make.bottom.equalToSuperview().inset(29)
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
