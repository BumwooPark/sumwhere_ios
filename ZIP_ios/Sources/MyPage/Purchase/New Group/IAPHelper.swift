//
//  IAPHelper.swift
//  ZIP_ios
//
//  Created by BumwooPark on 06/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//
import StoreKit
import RxSwift
import RxCocoa
import Moya

class IAPHelper: NSObject{
  
  let parentViewController: UIViewController
  private let disposeBag = DisposeBag()
  let products = BehaviorRelay<[SKProduct]>(value: [])
  
  
  let productsList = AuthManager.instance
    .provider
    .request(.IAPList)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[PurchaseProduct]>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  init(_ parentViewController: UIViewController) {
    self.parentViewController = parentViewController
    super.init()
    SKPaymentQueue.default().add(self)
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

extension IAPHelper: SKPaymentTransactionObserver{
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions{
      switch transaction.transactionState{
      case .purchased:
        complete(transaction: transaction)
      case .failed:
        fail(transaction: transaction)
      case .restored:
        restore(transaction: transaction)
      case .deferred:
        break
      case .purchasing:
        break
      }
    }
  }
  
  public func complete(transaction: SKPaymentTransaction){
    SKPaymentQueue.default().finishTransaction(transaction)
    
    let identifier = transaction.payment.productIdentifier
    
    let receiptURL = Bundle.main.appStoreReceiptURL
    do {
      let receipt = try Data(contentsOf: receiptURL!)
      
      let validateReceipt = AuthManager.instance
        .provider
        .request(.IAPSuccess(receipt: receipt.base64EncodedString(),identifier: identifier))
        .filterSuccessfulStatusCodes()
        .map(ResultModel<Bool>.self)
        .map{$0.result}
        .asObservable()
        .unwrap()
        .materialize()
        .share()
        
      validateReceipt
        .elements()
        .subscribeNext(weak: self) { (weakSelf) -> (Bool) -> Void in
          return { result in
            if result{
              weakSelf.parentViewController.navigationController?.popViewController(animated: true)
            }
          }
      }.disposed(by: disposeBag)
      
      validateReceipt
        .errors()
        .subscribe(onNext: { (err) in
          (err as? MoyaError)?.GalMalErrorHandler()
        }).disposed(by: disposeBag)
      
    }catch let error {
      log.error(error)
    }
  }
  
  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
    log.info("restore... \(productIdentifier)")
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  private func fail(transaction: SKPaymentTransaction) {
    log.info("fail...")
    if let transactionError = transaction.error as NSError?,
      let localizedDescription = transaction.error?.localizedDescription,
      transactionError.code != SKError.paymentCancelled.rawValue {
      log.info("Transaction Error: \(localizedDescription)")
    }
    SKPaymentQueue.default().finishTransaction(transaction)
  }
}
