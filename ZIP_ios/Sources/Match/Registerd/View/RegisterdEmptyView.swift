//
//  RegisterdEmptyView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 18/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

final class RegisterdEmptyView: UIView {
  
  private var didUpdateConstraint = false
  private let imageView: UIImageView = {
    let view = UIImageView(image: #imageLiteral(resourceName: "registedemptyimage.png"))
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    let attributedString = NSMutableAttributedString(
      string: "알맞은 친구가 없어요 T.T\n\n",
      attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 20),.foregroundColor: #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)])
    attributedString.append(NSAttributedString(
      string: "나와 맞는 친구를 찾는대로\n알려드릴께요!",
      attributes: [.font: UIFont.AppleSDGothicNeoRegular(size: 15),.foregroundColor: #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)]))
    label.attributedText = attributedString
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    addSubview(titleLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-50)
        make.height.width.equalTo(80)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(imageView.snp.bottom).offset(30)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
