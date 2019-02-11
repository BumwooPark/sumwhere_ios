//
//  TripProxyController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 25/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import NVActivityIndicatorView
import AMScrollingNavbar


class TripProxyController: ScrollingNavigationController {
  private let disposeBag = DisposeBag()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    view.backgroundColor = .white
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    checkUserRegisterd()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func checkUserRegisterd(){
    AuthManager.instance.provider
      .request(.GetAllTrip)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<TripModel>.self)
      .map{$0.result}
      .asObservable()
      .retry(.exponentialDelayed(maxCount: 2, initial: 2, multiplier: 2))
      .subscribe(weak: self) { (weakSelf) -> (Event<TripModel?>) -> Void in
        return {event in
          log.info(event)
          switch event {
          case .next(let model):
            if let model = model {
              weakSelf.setViewControllers([RegisterdViewController(model: model)], animated: true)
            }else {
              weakSelf.setViewControllers([MainMatchViewController()], animated: true)
            }
          case .error(let error):
            
            log.error(error)
            break
          default:
            break
          }
        }
      }.disposed(by: disposeBag)
  }
}


