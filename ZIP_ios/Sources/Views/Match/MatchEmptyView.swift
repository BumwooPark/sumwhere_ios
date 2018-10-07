//
//  MatchEmptyView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 07/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

final class MatchEmptyView: UIView {
  
  var didUpdateContraint = false
  
  private let imageView: UIImageView = {
    let view = UIImageView()
    view.image = #imageLiteral(resourceName: "combinedShape2.png")
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "매칭할 티켓이 없어요!"
    label.font = .AppleSDGothicNeoSemiBold(size: 20)
    label.textColor = #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)
    return label
  }()
  
  private let detailLabel: UILabel = {
    let label = UILabel()
    label.text = "여행을 등록하면\n동행티켓이 발급됩니다."
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = .AppleSDGothicNeoMedium(size: 18)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  public let addButton: UIButton = {
    let button = UIButton()
    button.setTitle("여행 등록하기", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1), for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 12.8)
    button.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    button.layer.borderWidth = 1.3
    button.layer.cornerRadius = 1.3
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(detailLabel)
    addSubview(addButton)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateContraint{
      
      imageView.snp.makeConstraints { (make) in
        make.height.width.equalTo(103)
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-100)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(imageView.snp.bottom).offset(24)
        make.centerX.equalToSuperview()
      }
      
      detailLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
      }
      
      addButton.snp.makeConstraints { (make) in
        make.top.equalTo(detailLabel.snp.bottom).offset(22)
        make.centerX.equalToSuperview()
        make.width.equalTo(104)
        make.height.equalTo(37)
      }
      
      didUpdateContraint = true
    }
    
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
