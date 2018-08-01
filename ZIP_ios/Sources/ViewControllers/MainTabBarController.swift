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
import SideMenu

class MainTabBarController: UITabBarController{
  private let disposeBag = DisposeBag()
  let mainViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MainViewController())
    naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icons8-back-36")
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icons8-back-36")
    naviVC.navigationBar.backItem?.title = String()
    let tabBar = UITabBarItem(title: "여행", image: #imageLiteral(resourceName: "on"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let writerViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: PlanViewController())
    let tabBar = UITabBarItem(title: "매칭", image: #imageLiteral(resourceName: "matchoff"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let settingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: ConfigureViewController())
    let tabBar = UITabBarItem(title: "설정", image: #imageLiteral(resourceName: "configoff"), tag: 0)
    naviVC.navigationBar.prefersLargeTitles = true
    naviVC.navigationItem.largeTitleDisplayMode = .always
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.backgroundImage = UIImage.resizable().color(.clear).image
    tabBar.shadowImage = UIImage()
    
    let titleLabel = UILabel()
    titleLabel.text = "갈래말래"
    titleLabel.font = UIFont.BMJUA(size: 15)
    titleLabel.textColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    self.navigationItem.titleView = titleLabel
    self.viewControllers = [
     mainViewController, writerViewController
      , settingViewController
    ]
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
//      self?.profileAlertView()
//    }
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
