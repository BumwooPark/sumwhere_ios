//
//  GADateCell.swift
//  ZIP_ios
//
//  Created by xiilab on 03/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Eureka

public class GADateCell: Cell<Date>, CellType {
  var didUpdateConstraint = false
  let iconImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "currentTimeIcon.png")
    return imageView
  }()
  
  open let currentLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  public override func setup() {
    super.setup()
    contentView.addSubview(iconImage)
    contentView.addSubview(currentLabel)
    height = {67}
    setNeedsUpdateConstraints()
  }
  
  public override func update() {
    super.update()
    selectionStyle = row.isDisabled ? .none : .default
  }
  open override func didSelect() {
    super.didSelect()
    row.deselect()
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
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
}

public final class GADateTimeInlineRow<T>: GADateTimeInlineRow_, RowType, InlineRowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    onExpandInlineRow { cell, row, _ in
      let color = cell.currentLabel.textColor
      row.onCollapseInlineRow { cell, _, _ in
        cell.currentLabel.textColor = color
      }
      cell.currentLabel.textColor = cell.tintColor
    }
  }
  
  public override func customDidSelect() {
    super.customDidSelect()
    if !isDisabled {
      toggleInlineRow()
    }
  }
}

open class GADateTimeInlineRow_: GADateInlineFieldRow {

  public typealias InlineRow = DateTimePickerRow

  public required init(tag: String?) {
    super.init(tag: tag)
    dateFormatter?.timeStyle = .short
    dateFormatter?.dateStyle = .short
  }

  open func setupInlineRow(_ inlineRow: DateTimePickerRow) {
    configureInlineRow(inlineRow)
  }
  
  func configureInlineRow(_ inlineRow: DatePickerRowProtocol) {
    inlineRow.minimumDate = minimumDate
    inlineRow.maximumDate = maximumDate
    inlineRow.minuteInterval = minuteInterval
  }
}


open class GADateInlineFieldRow: Row<GADateCell>, DatePickerRowProtocol, NoValueDisplayTextConformance {

  /// The minimum value for this row's UIDatePicker
  open var minimumDate: Date?

  /// The maximum value for this row's UIDatePicker
  open var maximumDate: Date?

  /// The interval between options for this row's UIDatePicker
  open var minuteInterval: Int?

  /// The formatter for the date picked by the user
  open var dateFormatter: DateFormatter?

  open var noValueDisplayText: String?

  required public init(tag: String?) {
    super.init(tag: tag)
    minimumDate = Date()
    maximumDate = Date()
    dateFormatter = DateFormatter()
    dateFormatter?.locale = Locale.current
    displayValueFor = { [unowned self] value in
      guard let val = value, let formatter = self.dateFormatter else { return nil }
      return formatter.string(from: val)
    }
  }
}
