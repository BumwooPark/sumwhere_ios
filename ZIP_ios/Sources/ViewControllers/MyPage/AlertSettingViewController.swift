//
//  AlertViewController.swift
//  ZIP_ios
//
//  Created by BumwooPark on 2018. 8. 23..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka
import RxSwift
import RxSwiftExt
import NVActivityIndicatorView

class AlertSettingViewController: FormViewController, NVActivityIndicatorViewable{
  private let disposeBag = DisposeBag()
  
  let push = AuthManager.instance.provider.request(.GetPush)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<AlertModel>.self)
    .map{$0.result}
    .asObservable()
    .retry(.delayed(maxCount: 3, time: 5.0)) 
    .unwrap()
    .materialize()
    .share()
  
  var pushAlertItem: AlertModel?{
    didSet{
      form.allSections[0].reload()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    push.elements()
      .subscribeNext(weak: self) { (weakSelf) -> (AlertModel) -> Void in
      return { model in
        weakSelf.pushAlertItem = model
        weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
      }
    }.disposed(by: disposeBag)
    
    
    push.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
          weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        }
    }.disposed(by: disposeBag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    
    startAnimating(CGSize(width: 50, height: 50), type: .circleStrokeSpin,color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1), backgroundColor: .clear,fadeInAnimation: NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    
    let push = AuthManager.instance.provider.request(.GetPush)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<AlertModel>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
    
    push
      .elements()
      .subscribeNext(weak: self) { (weakSelf) -> (AlertModel) -> Void in
        return {model in
          log.info(model)
        }
    }.disposed(by: disposeBag)
    
    push.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {error in
          log.error(error)
        }
    }.disposed(by: disposeBag)
    
    
    form +++
      Section("알림 설정")
//      <<< SwitchRow("모든알림", { (row) in
//        row.title = "모든알림"
//        row.value = pushAlertItem?.isAllTrue() ?? true
//      }).cellSetup({ (cell, row) in
//        cell.backgroundColor = .clear
//        cell.height = {50}
//        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
//      }).onChange {[weak self] row in
//        guard let value = row.value else {return}
//        self?.pushAlertItem?.setAll(bool: value)
//        self?.form.allSections[0].reload()
//        self?.update()
//        row.updateCell()
//        }.cellUpdate({[weak self] (cell, row) in
//          row.value = self?.pushAlertItem?.isAllTrue()
//        })
    
      <<< SwitchRow("동행매칭알림", { (row) in
        row.title = "동행매칭알림"
        row.value = pushAlertItem?.matchAlert ?? true
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      }).onChange({[weak self] (row) in
        guard let pushvalue = row.value else {return}
        self?.pushAlertItem?.matchAlert = pushvalue
        self?.update()
        row.updateCell()
      })
    
      <<< SwitchRow("친구요청알림", { (row) in
        row.title = "친구요청알림"
        row.value = pushAlertItem?.friendAlert ?? true
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      }).onChange({[weak self] (row) in
        guard let pushvalue = row.value else {return}
        self?.pushAlertItem?.friendAlert = pushvalue
        self?.update()
        row.updateCell()
      })
    
      <<< SwitchRow("채팅알림", { (row) in
        row.title = "채팅알림"
        row.value = pushAlertItem?.chatAlert ?? true
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      }).onChange({[weak self] (row) in
        guard let pushvalue = row.value else {return}
        self?.pushAlertItem?.chatAlert = pushvalue
        self?.update()
        row.updateCell()
      })
    
      <<< SwitchRow("이벤트알림", { (row) in
        row.title = "이벤트알림"
        row.value = pushAlertItem?.eventAlert ?? true
      }).cellSetup({ (cell, row) in
        cell.backgroundColor = .clear
        cell.height = {50}
        cell.switchControl.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      }).onChange({[weak self] (row) in
        guard let pushvalue = row.value else {return}
        self?.pushAlertItem?.eventAlert = pushvalue
        self?.update()
        row.updateCell()
      })
  }
  
  
  func update(){
    guard let model = pushAlertItem else {return}
    startAnimating(CGSize(width: 50, height: 50), type: .circleStrokeSpin,color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1), backgroundColor: .clear,fadeInAnimation: NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    AuthManager
      .instance
      .provider
      .request(.UpdatePush(model: model))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<Bool>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .subscribe(weak: self) { (weakSelf) -> (Event<Bool>) -> Void in
        return {event in
          weakSelf.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
          switch event{
          case .next(let element):
            log.info(element)
          case .error(let error):
            log.error(error)
          default:
            break
          }
        }
    }.disposed(by: disposeBag)
  }
}
