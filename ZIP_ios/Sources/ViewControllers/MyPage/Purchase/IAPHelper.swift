//
//  IAPHelper.swift
//  ZIP_ios
//
//  Created by xiilab on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import StoreKit
import RxSwift
import RxCocoa
import Moya

class IAPHelper: NSObject{
  
  private let disposeBag = DisposeBag()
  let products = BehaviorRelay<[SKProduct]>(value: [])
  
  let productsList = AuthManager.instance.provider.request(.IAPList)
  .filterSuccessfulStatusCodes()
  .map(ResultModel<[PurchaseProduct]>.self)
  .map{$0.result}
  .asObservable()
  .unwrap()
  .materialize()
  .share()
  
  
  override init() {
    super.init()
  }
  
  func fetchProducts() {
    productsList.elements()
      .subscribeNext(weak: self) { (weakSelf) -> ([PurchaseProduct]) -> Void in
        return { products in
          let productIDs = Set(products.compactMap({ $0.productName}))
          let request = SKProductsRequest(productIdentifiers: productIDs)
          request.delegate = weakSelf
          request.start()
        }
      }.disposed(by: disposeBag)
    
    productsList.errors()
      .subscribe(onNext: { (error) in
        (error as? MoyaError)?.GalMalErrorHandler()
      }).disposed(by: disposeBag)
  }
  
  func purchase(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
    
  }
  
  func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}


extension IAPHelper: SKProductsRequestDelegate{
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    response.invalidProductIdentifiers.forEach { product in
      log.info("Invalid: \(product)")
    }
    var tempProducts:[SKProduct] = []
    response.products.forEach { product in
      tempProducts.append(product)
    }
    
    tempProducts.sort { (product1, product2) -> Bool in
      return product1.price.compare(product2.price).rawValue == -1 ? true : false
    }
    
    products.accept(tempProducts)
  }
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    log.info("Error for request: \(error.localizedDescription)")
  }
}
