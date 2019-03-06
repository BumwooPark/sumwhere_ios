//
//  HistoryEmptyView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 02/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

class HistoryReceiveEmptyView: UIView {
  private var didUpdateConstraint = false
  
  private let imageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "iconReceive.png"))
    return imageView
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    let attributedString = NSMutableAttributedString(string: "받은 요청 이력이 없습니다.\n\n",
                                                     attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 20),.foregroundColor: #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)])
    attributedString.append(NSAttributedString(string: "먼저 동행을 제안하면\n매칭이 더욱더 빠르게 이루어져요!",
                                               attributes: [.font: UIFont.AppleSDGothicNeoRegular(size: 15),.foregroundColor: #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)]))
    label.attributedText = attributedString
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(imageView)
    addSubview(label)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      imageView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-50)
        make.width.height.equalTo(70)
      }
      
      label.snp.makeConstraints { (make) in
        make.top.equalTo(imageView.snp.bottom).offset(20)
        make.centerX.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
