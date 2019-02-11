//
//  DetailTripCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 10/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa

final class DetailTripCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  var selectAction: PublishRelay<Int>?
  var item: CountryTripPlace?{
    didSet{
      guard let item = item else {return}
      let attributedString = NSMutableAttributedString(string: item.discription+"\n", attributes: [.font: UIFont.AppleSDGothicNeoLight(size: 14)])
      attributedString.append(NSAttributedString(string: item.trip, attributes: [.font: UIFont.AppleSDGothicNeoBold(size: 20)]))
      titleLabel.attributedText = attributedString
      imageView.kf.setImage(with: URL(string: item.imageURL.addSumwhereImageURL())!, options: [.transition(.fade(0.2))])
    }
  }
  
  private var didUpdateConstraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  private let submitButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    button.layer.cornerRadius = 5
    button.setTitle("여행지 선택", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 15)
    button.isUserInteractionEnabled = true
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleLabel)
    contentView.addSubview(imageView)
    contentView.addSubview(submitButton)
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 10
    submitButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.selectAction?.accept(weakSelf.tag)
        }
      }.disposed(by: disposeBag)
    
    setNeedsUpdateConstraints()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(20)
        make.left.equalToSuperview().inset(34)
      }
      
      imageView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(34)
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
        make.bottom.equalTo(submitButton.snp.top).offset(-10)
      }
      
      submitButton.snp.makeConstraints { (make) in
        make.bottom.equalToSuperview().inset(10)
        make.left.right.equalToSuperview().inset(34)
        make.height.equalTo(50)
      }
      
      didUpdateConstraint = true
    }
    
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
