//
//  PurchaseViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import StoreKit
import RxSwift
import RxCocoa
import RxDataSources
import NVActivityIndicatorView

class PurchaseViewController: UIViewController,NVActivityIndicatorViewable{
  private let helper = IAPHelper()
  private let disposeBag = DisposeBag()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<PurchaseViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: PurchaseCell.self), for: idx) as! PurchaseCell
    cell.item = item as? SKProduct
    return cell
  },configureSupplementaryView: {ds,cv,kind,idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: PurchaseHeaderView.self), for: idx) as! PurchaseHeaderView
    view.label.text = ds.sectionModels[idx.section].title
    return view
  })
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 60)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 20)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    collectionView.register(PurchaseCell.self, forCellWithReuseIdentifier: String(describing: PurchaseCell.self))
    collectionView.register(PurchaseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PurchaseHeaderView.self))
    return collectionView
  }()
  
  override func loadView() {
    super.loadView()
    view = collectionView
    startAnimating(CGSize(width: 50, height: 50),type: .circleStrokeSpin, color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1),backgroundColor: .clear, fadeInAnimation: NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    helper.fetchProducts()
    
    let products = helper.products
      .map{[PurchaseViewModel(title: "KEY구매", items: $0)]}
      .share()
    
    products
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    products
      .subscribe(weak: self, { (weakSelf) -> (Event<[PurchaseViewModel]>) -> Void in
        return {_ in
          weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        }
      }).disposed(by: disposeBag)
    
    
    collectionView.rx.modelSelected(SKProduct.self)
      .bind(onNext: helper.purchase)
      .disposed(by: disposeBag)
  }
}

extension PurchaseViewController: SKPaymentTransactionObserver{
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
  }
}
