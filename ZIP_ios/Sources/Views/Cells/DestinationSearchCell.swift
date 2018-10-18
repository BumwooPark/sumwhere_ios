//
//  DestinationSearchCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 28..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class DestinationSearchCell: UITableViewCell{
  
  var didUpdateConstraint = false
  var item: (TripType?,String?){
    didSet{
      guard let itemString = item.0?.trip ,let searchString = item.1 else {return}
      let attributeString = NSMutableAttributedString(string: itemString)
      
      guard let range: Range<String.Index> = itemString.range(of: searchString) else {return}
      let location : Int = itemString.distance(from: itemString.startIndex, to: range.lowerBound)
      let length : Int = searchString.count
      attributeString.addAttributes([.foregroundColor : UIColor.black], range: NSRange(location: location, length: length))
      destinationLabel.attributedText = attributeString
      countryLabel.text = item.0?.country
    }
  }
  
  let destinationLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 16)
    label.textColor = .lightGray
    return label
  }()
  
  let countryLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 16)
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(destinationLabel)
    contentView.addSubview(countryLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      destinationLabel.snp.makeConstraints { (make) in
        make.bottom.top.equalToSuperview()
        make.left.equalTo(contentView.snp.leftMargin).inset(10)
      }
      
      countryLabel.snp.makeConstraints { (make) in
        make.centerY.equalTo(destinationLabel)
        make.right.equalToSuperview().inset(20)
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
