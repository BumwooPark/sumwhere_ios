//
//  DestinationSearchCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 28..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class DestinationSearchCell: UITableViewCell{
  
  var didUpdateConstraint = false
  var item: (DestinationModel?,String?){
    didSet{
      guard let itemString = item.0?.trip ,let searchString = item.1 else {return}
      let attributeString = NSMutableAttributedString(string: itemString)
      
      let range: Range<String.Index> = itemString.range(of: searchString)!
      let location : Int = itemString.distance(from: itemString.startIndex, to: range.lowerBound)
      let length : Int = searchString.count
      attributeString.addAttributes([.foregroundColor : UIColor.black], range: NSRange(location: location, length: length))
      destinationLabel.attributedText = attributeString
    }
  }
  
  let destinationLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.BMJUA(size: 15)
    label.textColor = .lightGray
    return label
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(destinationLabel)
    setNeedsUpdateConstraints()
  }
  
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      destinationLabel.snp.makeConstraints { (make) in
        make.bottom.top.equalToSuperview()
        make.left.equalTo(contentView.snp.leftMargin).inset(10)
      }
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
