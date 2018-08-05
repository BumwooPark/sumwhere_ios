//
//  SetProfileViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 14..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit
import Eureka
import TLPhotoPicker
import RxCocoa
import RxSwift
import RxGesture
import SwiftDate
import Moya


class SetProfileViewController: FormViewController{
  let disposeBag = DisposeBag()

  var item: UserModel?
  var images = [UIImage?](repeating: nil, count: 5)
  let configure: Bool
  
  let lastSection = Section()
  
  init(config: Bool) {
    configure = config
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.backgroundColor = .white
    title = "프로필 등록"
    getProfile()
    navigationItem.largeTitleDisplayMode = .always
    
    form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
    form
      +++ Section(){ section in
        section.tag = "headersection"
        var header = HeaderFooterView<ProfileHeaderView>(.class)
        header.height = {100}
        
        header.onSetupView = {[unowned self] view, _ in
          view.backgroundColor = .white
          view.viewController = self
        }
        section.header = header
      }
      
      +++ Section("프로필")
      
      <<< NicknameRow(){
        $0.title = "닉네임"
        $0.tag = "nickname"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        }).onChange({[weak self] (row) in
          self?.item?.nickname = row.cell.textField.text!
        }).cellUpdate({ (cell, row) in
          row.cell.textField.text = self.item?.nickname
        })
      
      <<< DateInlineRow(){
        $0.title = "생년월일"
        $0.tag = "birthday"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        }).cellUpdate({[weak self] (cell, row) in
          if self?.item?.profile?.birthday == String(){
            row.value = Date(timeIntervalSinceNow: 0)
          }else{
            row.value = self?.item?.profile?.birthday.toISODate()?.date
          }
        }).onChange({[weak self] (row) in
          guard let `self` = self else {return}
          self.item?.profile?.birthday =  (row.value?.toFormat("yyyy-MM-dd"))!
        })
      
      <<< PickerInlineRow<String>(){
        $0.title = "성별"
        $0.tag = "gender"
        $0.options = ["여성","남성"]
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        })
      
      +++ Section("여행 스타일 - 최대 3개")
      
      <<< CustomPresenterRow(){
        $0.title = "여행스타일"
        $0.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
          return TripStyleViewController()
        }), onDismiss: {vc in
          _ = vc.navigationController?.popViewController(animated: true)
        })}.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        })
      
      <<< CustomPresenterRow(){
        $0.title = "성격"
        $0.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
          return TripStyleViewController()
        }), onDismiss: {vc in
          _ = vc.navigationController?.popViewController(animated: true)
        })
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        })
      
      <<< CustomPresenterRow(){
        $0.title = "매력포인트"
        $0.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
          return TripStyleViewController()
        }), onDismiss: {vc in
          _ = vc.navigationController?.popViewController(animated: true)
        })}.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        })
      
      <<< TagRow(){
          $0.tag = "style"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.tagListView.addTags(["명소투어","먹방투어","쇼핑투어","레저스포츠투어","이색투어","문화투어","호캉스","전망투어","스포츠투어","드라이브투어","패스티벌투어"])
        })
      
      
      +++ Section("자기소개")
      <<< TextAreaRow()
      
      +++ lastSection
      <<< ButtonRow(){
        $0.title = "완료"
        }.onCellSelection({ [weak self](cell, row) in
          self?.putProfile()
        }).cellSetup({ (button, row) in
          button.textLabel?.font = UIFont.BMJUA(size: 15)
          button.tintColor = .black
        })
    
    
    if configure{
      lastSection <<< ButtonRow(){
        $0.title = "취소"
        }.onCellSelection({[weak self] (cell, row) in
          self?.dismiss(animated: true, completion: nil)
        }).cellSetup({ (button, row) in
          button.textLabel?.font = UIFont.BMJUA(size: 15)
          button.tintColor = .black
        })
    }
  }
  
  private func getProfile(){
    AuthManager.provider.request(.user)
      .map(ResultModel<UserModel>.self)
      .retry(3)
      .subscribe(onSuccess: {[weak self] (model) in
        guard let `self` = self else {return}
        self.item = model.result
        for row in self.form.rows{
          row.updateCell()
        }
        self.tableView.reloadData()
      }) { (error) in
        log.error(error)
    }.disposed(by: disposeBag)
  }
  
  private func putProfile(){
    
    var multiparts:[MultipartFormData] = []
    multiparts.append(MultipartFormData(provider: .data((item?.profile?.area.data(using: .utf8))!), name: "area"))
    multiparts.append(MultipartFormData(provider: .data((item?.profile?.job.data(using: .utf8))!), name: "job"))
    multiparts.append(MultipartFormData(provider: .data((item?.profile?.birthday.data(using: .utf8))!), name: "birthday"))
    multiparts.append(MultipartFormData(provider: .data((item?.nickname?.data(using: .utf8))!), name: "nickname"))
    
    for (idx,image) in images.enumerated(){
      if image != nil {
        multiparts.append(MultipartFormData(provider: .data(UIImageJPEGRepresentation(image!, 1)!), name: "image\(idx+1)", fileName: "image\(idx+1)", mimeType: "image/jpeg"))
      }
    }
  
    AuthManager.provider.request(.createProfile(data: multiparts))
      .map(ResultModel<UserModel>.self)
      .subscribe(onSuccess: { (model) in
        model.alert(success: "환영합니다"){[weak self] in
          if self?.navigationController == nil {
           self?.dismiss(animated: true, completion: nil)
          }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
              AppDelegate.instance?.proxyController.makeRootViewController()
            })
            self?.navigationController?.popViewController(animated: true)
          }
        }
      }) { (error) in
        log.error(error)
    }.disposed(by: disposeBag)
  }
  
  func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection: Int) {
    
    if let view = view as? UITableViewHeaderFooterView {
      view.textLabel?.font = UIFont.BMJUA(size: 16)
    }
  }
}
