//
//  TripSearchHeader.swift
//  ZIP_ios
//
//  Created by xiilab on 24/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

class TripSearchHeader: UIView{
  
  private let gradientView = UIView()
  private var didUpdateConstraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "어디로 떠날까요?"
    label.font = .KoreanSWGI1R(size: 30)
    return label
  }()
  
  lazy var textField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(
      string: "여행지를 입력해 주세요",
      attributes: [.font : UIFont.AppleSDGothicNeoMedium(size: 15)])
    let leftView = UIImageView(image: #imageLiteral(resourceName: "searchIcon.png"), highlightedImage: nil)
    leftView.contentMode = .scaleAspectFit
    leftView.frame = CGRect(origin: .zero, size: CGSize(width: 25, height: 18))
    textField.leftView = leftView
    textField.leftViewMode = .always
    textField.font = .AppleSDGothicNeoMedium(size: 15)
    textField.setZIPClearButton()
    textField.clearButtonMode = .never
    return textField
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(titleLabel)
    addSubview(textField)
    addSubview(gradientView)
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint {
      titleLabel.snp.makeConstraints { (make) in
        make.leading.equalToSuperview().inset(23)
        make.bottom.equalTo(textField.snp.top).offset(-20)
      }
      
      textField.snp.makeConstraints { (make) in
        make.leading.trailing.equalToSuperview().inset(16)
        make.bottom.equalTo(gradientView.snp.top)
        make.height.equalTo(46)
      }
      
      gradientView.snp.makeConstraints { (make) in
        make.leading.trailing.equalTo(textField)
        make.bottom.equalToSuperview()
        make.height.equalTo(2)
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientView.gradientBackground(from: #colorLiteral(red: 0.2941176471, green: 0.5725490196, blue: 1, alpha: 1), to: #colorLiteral(red: 0.6352941176, green: 0.4784313725, blue: 1, alpha: 1), direction: GradientDirection.leftToRight)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
