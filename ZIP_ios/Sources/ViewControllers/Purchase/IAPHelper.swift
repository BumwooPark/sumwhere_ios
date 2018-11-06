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

class IAPHelper: NSObject{
  private let disposeBag = DisposeBag()
  let products = BehaviorRelay<[SKProduct]>(value: [])
  
  let key50 = "key50"
  let key100 = "key100"
  let key200 = "key200"
  let key400 = "key400"
  let key800 = "key800"
  

  override init() {
    super.init()
  }
  
  func fetchProducts() {
    let productIDs = Set([key50,key100,key200,key400,key800])
    let request = SKProductsRequest(productIdentifiers: productIDs)
    request.delegate = self
    request.start()
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
