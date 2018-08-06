//
//  NicknameRow.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka

public class NicknameCell: Cell<String>, CellType{
  
  let checkButton: UIButton = {
    let button = UIButton()
    button.setTitle("중복확인", for: .normal)
    button.titleLabel?.font = UIFont.BMJUA(size: 14)
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 5
    button.layer.borderColor = UIColor.red.cgColor
    button.setTitleColor(.red, for: .normal)
    button.layer.masksToBounds = true
    return button
  }()
  
  let textField: UITextField = {
    let field = UITextField()
    field.attributedPlaceholder = NSAttributedString(string: "닉네임 8자", attributes: [.font : UIFont.BMJUA(size: 14)])
    return field
  }()
  
  public override func setup() {
    super.setup()
    addSubview(textField)
    addSubview(checkButton)
    
    selectionStyle = .none
    
    textField.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.topMargin)
      make.left.equalToSuperview().inset(100)
      make.bottom.equalTo(contentView.snp.bottomMargin)
      make.width.equalTo(100)
    }
    
    checkButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(10)
      make.width.equalTo(80)
      make.centerY.equalToSuperview()
    }
  }
}


public final class NicknameRow: Row<NicknameCell>, RowType{
  public required init(tag: String?) {
    super.init(tag: tag)
    cellProvider = CellProvider<NicknameCell>()
  }
}
