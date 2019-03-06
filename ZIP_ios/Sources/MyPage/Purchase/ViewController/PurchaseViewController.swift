//
//  PurchaseViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import StoreKit
import RxSwift
import RxCocoa
import RxDataSources
import NVActivityIndicatorView
import Firebase

class PurchaseViewController: UIViewController,NVActivityIndicatorViewable{
  private lazy var helper = IAPHelper(self)
  private let disposeBag = DisposeBag()
  private let data = BehaviorRelay<[PurchaseViewModel]>(value: [])
  private let viewModel = PurchaseKeyViewModel()
  private let rightBarButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "이용내역", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    button.setTitleTextAttributes([.font: UIFont.AppleSDGothicNeoMedium(size: 15.2),.foregroundColor: #colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1)], for: .normal)
    return button
  }()
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<PurchaseViewModel>(configureCell: {ds,cv,idx,item in
    switch item{
    case is SKProduct :
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: PurchaseCell.self), for: idx) as! PurchaseCell
      cell.item = item as? SKProduct
      return cell
    case is RewardPurchase:
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: PurchaseRewardCell.self), for: idx) as! PurchaseRewardCell
      cell.item = item as? RewardPurchase
      return cell
    default:
      return UICollectionViewCell()
    }
  },configureSupplementaryView: {ds,cv,kind,idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: PurchaseHeaderView.self), for: idx) as! PurchaseHeaderView
    view.label.text = ds.sectionModels[idx.section].title
    return view
  })
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 20
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 60)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 20)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    collectionView.register(PurchaseCell.self, forCellWithReuseIdentifier: String(describing: PurchaseCell.self))
    collectionView.register(PurchaseRewardCell.self, forCellWithReuseIdentifier: String(describing: PurchaseRewardCell.self))
    collectionView.register(PurchaseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PurchaseHeaderView.self))
    collectionView.delegate = self
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
    
    self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    title = "스토어"
    let products = helper.products
      .map{[PurchaseViewModel(title: "KEY구매", items: $0),
            PurchaseViewModel(title: "무료KEY받기", items: [
              RewardPurchase(rewardType: RewardPurchase.RewardType.Advertisement(title: "광고시청", reward: 1, action: AdMobViewController()))])]}
      .share()

    products
      .bind(to: data)
      .disposed(by: disposeBag)
    
    data.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)

    products
      .subscribe(weak: self, { (weakSelf) -> (Event<[PurchaseViewModel]>) -> Void in
        return {_ in
          weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        }
      }).disposed(by: disposeBag)
    
    collectionView.rx
      .itemSelected
      .debug()
      .subscribeNext(weak: self){(weakSelf) ->(IndexPath) -> Void in
        return { idx in
          let item = weakSelf.data.value[idx.section].items[idx.item]
          switch idx.section{
          case 0:
            guard let product = item as? SKProduct else {return}
            weakSelf.helper.purchase(product: product)
          case 1:
            guard let product = item as? RewardPurchase else {return}
            product.action()
          default:
            break
          }
        }
    }.disposed(by: disposeBag)
    
    rightBarButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return { _ in
          weakSelf.navigationController?.pushViewController(PurchaseHistoryViewController(), animated: true)
        }
      }.disposed(by: disposeBag)
    
  }
}

extension PurchaseViewController: SKPaymentTransactionObserver{
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
  }
}

extension PurchaseViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
  }
}
