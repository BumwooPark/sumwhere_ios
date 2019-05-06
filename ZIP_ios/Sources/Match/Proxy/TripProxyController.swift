//
//  TripProxyController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 25/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import NVActivityIndicatorView
import AMScrollingNavbar
import Swinject

let tripRegisterContainer = Container()

class TripProxyController: ScrollingNavigationController {
  static let changer = PublishRelay<Void>()
  private let disposeBag = DisposeBag()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    view.backgroundColor = .white
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkUserRegisterd()
    TripProxyController.changer
      .bind(onNext: checkUserRegisterd)
      .disposed(by: disposeBag)
  }
  
  func checkUserRegisterd(){
//    AuthManager.instance.provider
//      .request(.GetAllTrip)
//      .filterSuccessfulStatusCodes()
//      .map(ResultModel<TripModel>.self)
//      .map{$0.result}
//      .asObservable()
//      .retry(.exponentialDelayed(maxCount: 2, initial: 2, multiplier: 2))
//      .subscribe(weak: self) { (weakSelf) -> (Event<TripModel?>) -> Void in
//        return {event in
//          switch event {
//          case .next(let model):
//            if let model = model {
//              tripRegisterContainer.register(TripModel.self, name: "own", factory: { _ in model })
//              weakSelf.setViewControllers([RegisterdViewController()], animated: true)
//            }else {
//              weakSelf.setViewControllers([MainMatchViewController()], animated: true)
//            }
//          case .error(let error):
//
//            log.error(error)
//            break
//          default:
//            break
//          }
//        }
//      }.disposed(by: disposeBag)
  }
}


