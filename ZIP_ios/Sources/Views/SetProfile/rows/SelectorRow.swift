//
//  StyleRow.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka

open class PresenterRow<Cell: CellType, VCType: TypedRowControllerType>: OptionsRow<Cell>, PresenterRowType where Cell: BaseCell, VCType: UIViewController, VCType.RowValue == Cell.Value {
  
  public var presentationMode: PresentationMode<VCType>?
  public var onPresentCallback: ((FormViewController, VCType) -> Void)?
  public typealias PresentedControllerType = VCType
  
  required public init(tag: String?) {
    super.init(tag: tag)
  }
  open override func customDidSelect() {
    super.customDidSelect()
    guard let presentationMode = presentationMode, !isDisabled else { return }
    if let controller = presentationMode.makeController() {
      controller.row = self
      controller.title = selectorTitle ?? controller.title
      onPresentCallback?(cell.formViewController()!, controller)
      presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
    } else {
      presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
    }
  }
}

final class CustomPresenterRow: PresenterRow<PushSelectorCell<String>, PresenterViewController>, RowType {
}

class PresenterViewController: UIViewController, TypedRowControllerType{
  TripStyleHeaderView
  var row: RowOf<String>!
  var onDismissCallback: ((UIViewController) -> Void)?
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(TripStyleCell.self, forCellWithReuseIdentifier: String(describing: TripStyleCell.self))
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    
    
    
  }
}
