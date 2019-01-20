//
//  MatchTypeCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

class MatchTypeCell: UICollectionViewCell{
  var disposeBag = DisposeBag()
  
  var submitAction: PublishRelay<Int>?
  var item: SampleModel?{
    didSet{
      titleLabel.text = item?.title
      bgImage.image = item?.image
      explainLabel.text = item?.subTitle
      submitButton.isHidden = !item!.isSelected
      explainLabel.isHidden = !item!.isSelected
    }
  }
  
  override var isSelected: Bool{
    didSet{
      submitButton.isHidden = isSelected
      explainLabel.isHidden = isSelected
    }
  }

  private var didUpdateConstraint = false
  
  private let bgImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.OTGulimL(size: 30)
    label.textColor = .white
    return label
  }()
  
  private let explainLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.AppleSDGothicNeoSemiBold(size: 11)
    label.textColor = .white
    return label
  }()
  
  private let submitButton: UIButton = {
    let button = UIButton()
    button.setTitle("매칭하러 가기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoBold(size: 12)
    button.layer.cornerRadius = 14
    button.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 0.59)
    return button
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(bgImage)
    contentView.addSubview(titleLabel)
    contentView.addSubview(submitButton)
    contentView.addSubview(explainLabel)
    setNeedsUpdateConstraints()
    
    submitButton.rx.tap
      .map{self.tag}
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {idx in
          weakSelf.submitAction?.accept(idx)
        }
    }.disposed(by: disposeBag)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    submitButton.rx.tap
      .map{self.tag}
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {idx in
          weakSelf.submitAction?.accept(idx)
        }
      }.disposed(by: disposeBag)
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      bgImage.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
      
      explainLabel.snp.makeConstraints { (make) in
        make.bottom.equalTo(titleLabel.snp.top).offset(-6)
        make.centerX.equalToSuperview()
      }
      
      submitButton.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(14)
        make.centerX.equalToSuperview()
        make.width.equalTo(121)
        make.height.equalTo(29)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
