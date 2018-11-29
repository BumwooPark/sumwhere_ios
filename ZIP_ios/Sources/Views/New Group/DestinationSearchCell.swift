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
  
  private let pin: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "locationPin.png")
    return imageView
  }()
  
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
    contentView.addSubview(pin)
    contentView.addSubview(destinationLabel)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      pin.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(35)
        make.centerY.equalToSuperview()
        make.height.equalTo(15)
        make.width.equalTo(12)
      }
      
      destinationLabel.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview()
        make.left.equalTo(pin.snp.right).offset(10)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
