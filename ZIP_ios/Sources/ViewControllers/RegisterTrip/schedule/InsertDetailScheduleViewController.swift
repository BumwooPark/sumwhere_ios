//
//  InsertDetailScheduleViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 12/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa


class InsertDetailScheduleViewController: UIViewController{
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  let viewModel = DetailScheduleViewModel()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  private let currentRegionButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  private let imageView: UIImageView = {
    var view = UIImageView()
    view.kf.indicatorType = .activity
    return view
  }()
  
  private let detailRegionField: UITextField = {
    let textField = UITextField()
    return textField
  }()
  
  private let activityField: UITextField = {
    let textField = UITextField()
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(imageView)
    view.addSubview(contentView)
    imageView.addSubview(titleLabel)
    imageView.addSubview(currentRegionButton)
    contentView.addSubview(detailRegionField)
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
          weakSelf.imageView.kf.setImage(with: URL(string: url.addSumwhereImageURL()), options: [.transition(.fade(0.2)),.cacheOriginalImage])
        }
      }.disposed(by: disposeBag)
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
        make.top.equalTo(currentRegionButton.snp.bottom).offset(15)
        make.right.left.equalToSuperview().inset(26)
      }
      
      contentView.snp.makeConstraints { (make) in
      }
      
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
