//
//  TripStyleView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class TripStyleHeaderView: UICollectionReusableView{
  
  var didUpdateConstraint = false
  
  let styleLabel: UILabel = {
    let label = UILabel()
    label.text = "여행 스타일을 골라주세요"
    label.font = UIFont.BMJUA(size: 20)
    label.textAlignment = .center
    return label
  }()
  
  let detailLabel: UILabel = {
    let label = UILabel()
    label.text = "최대 3개 선택 가능"
    label.font = UIFont.BMJUA(size: 14)
    label.textAlignment = .center
    return label
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [styleLabel,detailLabel])
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(stackView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      stackView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    
    super.updateConstraints()
  }
  
}
