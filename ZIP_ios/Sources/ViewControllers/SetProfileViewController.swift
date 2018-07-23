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

class SetProfileViewController: FormViewController{
  let disposeBag = DisposeBag()

  var item: ProfileModel?
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .white
    network()
    form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
    form
      +++ Section(){ section in
        var header = HeaderFooterView<ProfileHeaderView>(.class)
        header.height = {200}
        
        header.onSetupView = {[unowned self] view, _ in
          view.backgroundColor = .white
          view.viewController = self
          view.item = self.item
        }
        section.header = header
      }
      
      +++ Section("프로필")
      
      <<< TextRow(){
        $0.title = "이름"
        $0.tag = "username"
        }.cellSetup({(cell, row) in
          cell.textField.attributedPlaceholder = NSAttributedString(string: "이름을 입력해 주세요", attributes: [NSAttributedStringKey.font : UIFont.BMJUA(size: 15)])
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.textField.font = UIFont.BMJUA(size: 15)
        }).onChange({[weak self] (row) in
          self?.item?.username = row.cell.textField.text!
        }).cellUpdate({ (cell, row) in
          row.cell.textField.text = self.item?.username
        })
      
      <<< PickerInlineRow<String>(){
        $0.title = "지역"
        $0.tag = "area"
        $0.options = ["서울","경기"]
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
        }).onChange({ (row) in
          self.item?.area = row.value ?? String()
        }).cellUpdate({ (cell, row) in
          row.value = self.item?.area
        })
      
      <<< DateInlineRow(){
        $0.title = "생년월일"
        $0.tag = "birthday"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        }).cellUpdate({[weak self] (cell, row) in
          row.value = (self?.item?.birthday ?? String()).toISODate()?.date
        }).onChange({[weak self] (row) in
          guard let `self` = self else {return}
          self.item?.birthday =  row.value?.toString() ?? String()
        })
      
      <<< TextRow(){
        $0.title = "직업"
        $0.tag = "job"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.textField.font = UIFont.BMJUA(size: 15)
        }).cellUpdate({ (cell, row) in
           cell.textField.text = self.item?.job
        }).onChange({[weak self] (row) in
          guard let `self` = self else {return}
          self.item?.job =  row.cell.textField.text ?? String()
        })
      
      +++ Section("여행 스타일")
      <<< TagRow(){
          $0.tag = "style"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.tagListView.addTags(["전망 좋은대 갈래","먹방투어 갈래","각종 쇼핑투어 갈래","이색적인 관광지 갈래","레저스포츠 갈래","스포츠(등산 골프 운동 볼링)갈래","명소 갈래","대중교통 투어 갈래","저녁에 야시장에서 맥주 갈래","문화 공연 페스티벌 갈래","호텔 노블레스 휴가 갈래","외국 밤문화 갈래","해변가 갈래"])
        })
      
      +++ Section("가즈아")
      <<< ButtonRow(){
        $0.title = "완료"
        }.onCellSelection({ [weak self](cell, row) in
          self?.dismiss(animated: true, completion: nil)
        }).cellSetup({ (button, row) in
          button.textLabel?.font = UIFont.BMJUA(size: 15)
          button.tintColor = .black
        })
  }
  
  private func network(){
    AuthManager.provider.request(.getProfile)
      .map(ResultModel<ProfileModel>.self)
      .subscribe(onSuccess: {[weak self] (model) in
        guard let `self` = self else {return}
        self.item = model.result
        for row in self.form.rows{
          row.updateCell()
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
