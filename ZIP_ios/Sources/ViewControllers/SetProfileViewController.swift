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
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .white
    getProfile()
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
      
      <<< TextRow(){
        $0.title = "닉네임"
        $0.tag = "nickname"
        }.cellSetup({(cell, row) in
          cell.textField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해 주세요", attributes: [NSAttributedStringKey.font : UIFont.BMJUA(size: 15)])
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.textField.font = UIFont.BMJUA(size: 15)
        }).onChange({[weak self] (row) in
          self?.item?.nickname = row.cell.textField.text!
        }).cellUpdate({ (cell, row) in
          row.cell.textField.text = self.item?.nickname
        })
      
      <<< PickerInlineRow<String>(){
        $0.title = "지역"
        $0.tag = "area"
        $0.options = ["서울","경기"]
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
        }).onChange({ (row) in
          self.item?.profile?.area = row.value ?? String()
        }).cellUpdate({ (cell, row) in
          row.value = self.item?.profile?.area
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
      
      <<< TextRow(){
        $0.title = "직업"
        $0.tag = "job"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.textField.font = UIFont.BMJUA(size: 15)
        }).cellUpdate({ (cell, row) in
           cell.textField.text = self.item?.profile?.job
        }).onChange({[weak self] (row) in
          guard let `self` = self else {return}
          self.item?.profile?.job =  row.cell.textField.text ?? String()
        })
      
      +++ Section("여행 스타일 - 최대 3개")
      <<< TagRow(){
          $0.tag = "style"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.tagListView.addTags(["명소투어","먹방투어","쇼핑투어","레저스포츠투어","이색투어","문화투어","호캉스","전망투어","스포츠투어","드라이브투어","패스티벌투어"])
        })
      
      +++ Section()
      <<< ButtonRow(){
        $0.title = "완료"
        }.onCellSelection({ [weak self](cell, row) in
          self?.putProfile()
        }).cellSetup({ (button, row) in
          button.textLabel?.font = UIFont.BMJUA(size: 15)
          button.tintColor = .black
        })
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
