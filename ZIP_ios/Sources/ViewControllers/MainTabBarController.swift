//
//  MainTabBarController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import PopupDialog
import SwiftyUserDefaults
import SwiftyImage
import RxSwift
import RxCocoa

class MainTabBarController: UITabBarController{
  private let disposeBag = DisposeBag()
  let mainViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MainViewController())
    let tabBar = UITabBarItem(title: "여행", image: #imageLiteral(resourceName: "icons8-prop_plane"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let writerViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: PlanViewController())
    let tabBar = UITabBarItem(title: "계획", image: #imageLiteral(resourceName: "edit_icon"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let settingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: ConfigureViewController())
    let tabBar = UITabBarItem(title: "설정", image: #imageLiteral(resourceName: "profile_icon"), tag: 0)
    naviVC.navigationBar.prefersLargeTitles = true
    naviVC.navigationItem.largeTitleDisplayMode = .always
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.backgroundImage = UIImage.resizable().color(.clear).image
    tabBar.shadowImage = UIImage()
    self.viewControllers = [
     mainViewController, writerViewController
      , settingViewController
    ]
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    profileCheck()
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
//      self?.profileAlertView()
//    }
  }
  
  private func profileCheck(){
    AuthManager.provider.request(.isProfile)
      .map(ResultModel<Bool>.self)
      .asObservable()
      .subscribe(onNext: {[weak self] (model) in
        if model.success{
          if !model.result!{
            self?.present(SetProfileViewController(), animated: true, completion: nil)
          }
        }
      }).disposed(by: disposeBag)
  }
  
//  private func profileAlertView(){
//
//    guard Defaults.hasKey(.isProfileSet) || !Defaults[.isProfileSet] else {return}
//
//    let popup = PopupDialog(title: "회원정보", message: "회원정보를 입력해 주세요")
//    let goButton = DefaultButton(title: "입력하러 갈래", height: 60, dismissOnTap: true) {[weak self] in
//      self?.present(SetProfileViewController(), animated: true, completion: nil)
//    }
//    let cancelButton = DefaultButton(title: "나중에 할래", height: 60, dismissOnTap: true){
//      Defaults[.isProfileSet] = true
//    }
//    popup.addButtons([goButton,cancelButton])
//    self.present(popup, animated: true, completion: nil)
//  }
}
