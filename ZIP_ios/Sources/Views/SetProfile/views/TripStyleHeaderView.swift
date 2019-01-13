//
//  TripTableHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 24..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift

class TripStyleHeaderView: UITableViewHeaderFooterView {
  typealias Item = SelectTripStyleModel
  
  var disposeBag = DisposeBag()
  
  
  var didUpdateConstraint = false
  var item: Item?{
    didSet{
      guard let item = item else {return}
      selectedButton.isSelected = item.isSelected
      
      let attributedString = NSMutableAttributedString(string: item.subTitle+"\n\n", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 10)])
      attributedString.append(NSAttributedString(string: item.title, attributes: [.font: UIFont.AppleSDGothicNeoRegular(size: 17)]))
      titleLabel.attributedText = attributedString
      selectedButton.isSelected = item.selectedData.count >= 3
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  private let commentLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoRegular(size: 17)
    return label
  }()
  
  public let selectedButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 14
    button.setTitle("선택하기", for: .normal)
    button.setTitle("선택완료", for: .selected)
    button.setTitleColor(#colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1), for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1), for: .selected)
    button.titleLabel?.font = .AppleSDGothicNeoSemiBold(size: 9)
    return button
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = .white
    contentView.addSubview(titleLabel)
    contentView.addSubview(commentLabel)
    contentView.addSubview(selectedButton)
    setNeedsUpdateConstraints()
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(43)
        make.top.equalToSuperview().inset(28)
      }
      
      commentLabel.snp.makeConstraints { (make) in
        make.left.equalTo(titleLabel)
        make.top.equalTo(titleLabel.snp.bottom).offset(6)
      }
      
      selectedButton.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(42)
        make.centerY.equalToSuperview()
        make.width.equalTo(51)
        make.height.equalTo(28)
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
