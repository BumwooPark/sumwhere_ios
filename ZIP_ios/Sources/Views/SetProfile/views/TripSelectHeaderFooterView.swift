//
//  TripSelectHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

final class TripSelectHeaderView: UICollectionReusableView{
  
  let titleLabel: UILabel = {
    let label = UILabel()
    let attributedString = NSMutableAttributedString(string: "어떤 장소를 선호하시나요?\n", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 17.6)])
    attributedString.append(NSAttributedString(string: "세개이상 선택해주세요.", attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 13.2),.foregroundColor: #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)]))
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class TripSelectFooterView: UICollectionReusableView{
  private let completeButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    button.setTitle("선택완료", for: .normal)
    button.setTitle("선택완료", for: .selected)
    button.setTitleColor(#colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1), for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(completeButton)
    completeButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
