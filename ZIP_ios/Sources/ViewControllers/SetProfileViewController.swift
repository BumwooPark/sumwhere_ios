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

class SetProfileViewController: FormViewController{
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .white
    form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
    form
      +++ Section(){ section in
        var header = HeaderFooterView<ProfileHeaderView>(.class)
        header.height = {200}
        
        header.onSetupView = {[unowned self] view, _ in
          view.backgroundColor = .white
          view.viewController = self
        }
        section.header = header
      }
      
      +++ Section("프로필")
      
      <<< TextRow(){
        $0.title = "이름"
        $0.placeholder = "이름을 입력해 주세요"
        }.cellSetup({ (cell, row) in
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.textField.font = UIFont.BMJUA(size: 15)
        })
      
      <<< PickerInlineRow<String>(){
        $0.title = "지역"
        $0.options = ["서울","경기"]
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
        })
      
      <<< DateInlineRow(){
        $0.title = "생년월일"
        $0.value = Date(timeIntervalSinceNow: 0)
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.detailTextLabel?.font = UIFont.BMJUA(size: 15)
        })
      
      <<< TextRow(){
        $0.title = "직업"
        }.cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.textField.font = UIFont.BMJUA(size: 15)
        })
      
      
      +++ Section("여행 스타일")
      
      <<< TagRow()
        .cellSetup({ (cell, row) in
          cell.textLabel?.font = UIFont.BMJUA(size: 15)
          cell.tagListView.addTags(["전망 좋은대 갈래","먹방투어 갈래","각종 쇼핑투어 갈래","이색적인 관광지 갈래","레저스포츠 갈래","스포츠(등산 골프 운동 볼링)갈래","명소 갈래","대중교통 투어 갈래","저녁에 야시장에서 맥주 갈래","문화 공연 페스티벌 갈래","호텔 노블레스 휴가 갈래","외국 밤문화 갈래","해변가 갈래"])
        })
    
    //      +++ Section("가즈아")
//
//      <<< ButtonRow(){
//        $0.title = "완료"
//        }.onCellSelection({ [weak self](cell, row) in
//          self?.dismiss(animated: true, completion: nil)
//        }).cellSetup({ (button, row) in
//          button.textLabel?.font = UIFont.BMJUA(size: 15)
//          button.tintColor = .black
//        })
    
  }
}
