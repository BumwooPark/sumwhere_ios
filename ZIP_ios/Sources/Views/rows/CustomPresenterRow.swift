//
//  StyleRow.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa
import RxDataSources

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

final class CustomPresenterRow: PresenterRow<PushSelectorCell<String>, TripStyleViewController>, RowType {
}

class TripStyleViewController: UIViewController, TypedRowControllerType{
  
  var row: RowOf<String>!
  var onDismissCallback: ((UIViewController) -> Void)?
  
  private let disposeBag = DisposeBag()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<TripStyleViewModel>(
    configureCell: {ds,cv,idx,item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TripStyleCell.self), for: idx) as! TripStyleCell
      return cell
  },configureSupplementaryView: {ds,cv,name,idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: TripStyleHeaderView.self), for: idx) as! TripStyleHeaderView
    return view
  })
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.register(TripStyleCell.self, forCellWithReuseIdentifier: String(describing: TripStyleCell.self))
    collectionView.register(TripStyleHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: TripStyleHeaderView.self))
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    navigationItem.largeTitleDisplayMode = .never
    Observable.just([TripStyleViewModel(items: [TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지"),TripStyleModel(id: 1, destination: "여행지")])])
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
}


