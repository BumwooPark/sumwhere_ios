//
//  MatchCell.swift
//  
//
//  Created by park bumwoo on 2018. 7. 30..
//

class MatchCell: UITableViewCell{
  
  var didUpdateConstraint = false
  
  var item: MatchType?{
    didSet{
      detailLabel.text = item?.detail
      titleLabel.text = item?.title
      keyButton.setTitle("\(item?.key)", for: .normal)
    }
  }
  
  let detailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.BMJUA(size: 15)
    return label
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.BMJUA(size: 20)
    return label
  }()
  
  let keyButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(detailLabel)
    contentView.addSubview(titleLabel)
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      detailLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(24)
        make.top.equalToSuperview().inset(28)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalTo(detailLabel)
        make.top.equalTo(detailLabel).offset(13)
      }
      
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  
}
