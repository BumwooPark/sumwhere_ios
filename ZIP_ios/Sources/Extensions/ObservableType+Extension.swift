//
//  ObservableType+Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 18..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

extension ObservableType where E == Moya.Response{
  func jsonMap()-> Observable<JSON>{
    return self.mapString()
      .map{JSON(parseJSON: $0)}
  }
}
