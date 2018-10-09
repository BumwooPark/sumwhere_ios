//
//  RegisterTripViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 09/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

final class RegisterTripViewModel{
  
  private let disposeBag = DisposeBag()
  public let dismissAction = PublishSubject<Void>()
  public let completeAction = PublishSubject<Void>()
  
  init() {
  }
}
