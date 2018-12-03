//
//  GALabelCell.swift
//  ZIP_ios
//
//  Created by xiilab on 03/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Eureka

public class GALabelCell: Cell<String>, CellType{
  var didUpdateConstraint = false
  
  let iconImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "onetimePin.png")
    return imageView
  }()
  
  private let currentLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let reloadButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "recycleButtonIcon.png"), for: .normal)
    return button
  }()
  
  public override func setup() {
    super.setup()
    contentView.addSubview(iconImage)
    contentView.addSubview(currentLabel)
    contentView.addSubview(reloadButton)
    height = {67}
    setNeedsUpdateConstraints()
  }
  public override func update() {
    super.update()
  }
  
  public override func updateConstraints() {
    if !didUpdateConstraint{
      iconImage.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(33)
        make.centerY.equalToSuperview()
      }
      
      currentLabel.snp.makeConstraints { (make) in
        make.left.equalTo(iconImage.snp.right).offset(20)
        make.centerY.equalToSuperview()
      }
      
      reloadButton.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(20)
        make.centerY.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
}

public final class GALabelRow: Row<GALabelCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    cellProvider = CellProvider<GALabelCell>()
  }
}

