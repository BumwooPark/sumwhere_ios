//
//  MoyaError + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

extension MoyaError{
  func GalMalErrorHandler(){
    switch self {
    case let .underlying(err, response):
      log.info(response)
      let error = err as NSError
      switch error.code{
      case -1004:
          AlertType.JDStatusBar.getInstance().show(isSuccess: false, message: "서버에 연결할 수 없습니다. 관리자에게 문의하세요")
      default:
        log.error(self)
        break
      }
    case let .statusCode(response):
      do {
        let data = try response.map(ResultModel<Bool>.self)
        AlertType.JDStatusBar.getInstance().show(isSuccess: false, message: data.error?.details ?? String())
      }catch{
        AlertType.JDStatusBar.getInstance().show(isSuccess: false, message: "에러")
      }
    default:
      log.error(self)
    }
  }
}


extension ObservableType where E == MoyaError?{
  func bindGalMalError() -> Disposable{
    return self.bind(onNext: {err in
      err?.GalMalErrorHandler()
    })
  }
}
