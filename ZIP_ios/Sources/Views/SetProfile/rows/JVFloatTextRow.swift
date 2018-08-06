//
//  NicknameRow.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 3..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka
import JVFloatLabeledTextField


public class JVFloatTextCell: Cell<String>, CellType{
  
  let textField: JVFloatLabeledTextField = {
    let field = JVFloatLabeledTextField()
    field.font = UIFont.BMJUA(size: 20)
    field.floatingLabel.font = UIFont.BMJUA(size: 15)
    return field
  }()
  
  public override func setup() {
    super.setup()
    addSubview(textField)
    height = {70}
    selectionStyle = .none
    textField.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 5))
    }
  }
  
  public override func update() {
    super.update()
    textField.text = row.value ?? String()
  }
}


public final class JVFloatTextRow: Row<JVFloatTextCell>, RowType{
  public required init(tag: String?) {
    super.init(tag: tag)
    cellProvider = CellProvider<JVFloatTextCell>()
  }
}

