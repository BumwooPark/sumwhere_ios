//
//  WriterCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 23..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import Eureka


class CustomView: UIView{
  
  let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame:frame)
    addSubview(titleLabel)
    
    self.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.7960784314, blue: 0.9568627451, alpha: 1)
    self.layer.cornerRadius = 10
    
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOffset = CGSize(width: 2, height: 4)
    self.layer.shadowOpacity = 1
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(10)
      make.top.equalToSuperview().inset(10)
    }
  }
 
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public class WriterCell: Cell<Bool>, CellType {
  
  let customView = CustomView()
  
  public func setup(title:String) {
    super.setup()
    contentView.backgroundColor = .white
    contentView.addSubview(customView)
    customView.titleLabel.text = title
    selectionStyle = .none
    customView.snp.makeConstraints { (make) in
      make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
  }
  
  func switchValueChanged(){
    row.updateCell() // Re-draws the cell which calls 'update' bellow
  }
  
  public override func update() {
    super.update()
  }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class WriterRow: Row<WriterCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    // We set the cellProvider to load the .xib corresponding to our cell
    cellProvider = CellProvider<WriterCell>()
  }
}
