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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    RegisterdTrip {[weak self] (model) in
      if model.count == 0 {
        self?.setViewControllers([MainMatchViewController()], animated: true)
      }else {
        let tempdata = model[0]
        self?.setViewControllers([RegisterdViewController(model: tempdata)], animated: true)
      }
    }
  }
  
  func RegisterdTrip(register: @escaping (([TripModel]) -> Void)){
    AuthManager.instance.provider.request(.GetAllTrip)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[TripModel]>.self)
      .map{$0.result}
      .asObservable()
      .map{
        guard let item = $0 else {return []}
        return item
      }
      .retry(.exponentialDelayed(maxCount: 3, initial: 2, multiplier: 2))
      .subscribe(weak: self) { (weakSelf) -> (Event<[TripModel]>) -> Void in
        return {event in
          switch event {
          case .next(let model):
            register(model)
          case .error(let error):
            log.error(error)
          default:
            break
          }
        }
    }.disposed(by: disposeBag)
  }
  
  
  
}


