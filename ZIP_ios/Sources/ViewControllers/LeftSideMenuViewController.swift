//
//  SideMenuViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 15..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

class LeftSideMenuViewController: FormViewController{
  let disposeBag = DisposeBag()
  
  let network = AuthManager.provider
    .request(.user)
    .map(ResultModel<UserModel>.self)
    .asObservable()
    .share()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getUserInfo()
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = .white
    tableView.isScrollEnabled = false
    form +++ Section("갈래말래"){
      var header = HeaderFooterView<MenuHeaderView>(.class)
      header.onSetupView = {[weak self]( view,section) in
        guard let `self` = self else {return}
        view.profileSetting(observer: self.network)
      }
        
      
      header.height = {250}
      $0.header = header
      }
      
      <<< LabelRow(){$0.title = "프로필 수정"}.onCellSelection({[weak self] (cell, row) in
        self?.present(SetProfileViewController(config: true), animated: true, completion: nil)
      })
      <<< LabelRow(){$0.title = "내 여행"}.onCellSelection({ [weak self] (cell, row) in
        self?.present(MyTripViewController(), animated: true, completion: nil)
      })
      <<< LabelRow(){$0.title = "알림"}
      <<< LabelRow(){$0.title = "상점"}
      <<< LabelRow(){$0.title = "문의하기"}
      <<< LabelRow(){
        $0.title = "설정"
        $0.onCellSelection({[weak self] (cell, row) in
          guard let `self` = self else {return}
          self.present(ConfigureViewController(), animated: true, completion: nil)
        })
    }
  }
  
  func getUserInfo(){
    AuthManager.provider.request(.user)
      .map(ResultModel<UserModel>.self)
      .subscribe(onSuccess: { (model) in
        log.info(model.result)
      }) { (error) in
        log.error(error)
    }.disposed(by: disposeBag)
  }
  
}
