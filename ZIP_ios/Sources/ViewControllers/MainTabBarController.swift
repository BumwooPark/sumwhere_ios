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
    naviVC.navigationBar.backIndicatorTransitionMaskImage =  #imageLiteral(resourceName: "icons8-long_arrow_left_filled")
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icons8-long_arrow_left_filled")
//    naviVC.navigationBar.tintColor = .white
    naviVC.navigationBar.backItem?.title = String()
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "홈", image: #imageLiteral(resourceName: "icons8-home"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let historyViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: CurrentMatchViewController())
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "동행", image: #imageLiteral(resourceName: "icons8-user-groups-32"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let writerViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: TripViewController())
    naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icons8-long_arrow_left_filled").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icons8-long_arrow_left_filled").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backItem?.title = String()
    naviVC.navigationBar.prefersLargeTitles = true
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    naviVC.navigationBar.largeTitleTextAttributes = [.font: UIFont.NotoSansKRBold(size: 40)]
    let tabBar = UITabBarItem(title: "매칭", image: #imageLiteral(resourceName: "icons8-find-user-male"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let chattingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: ChatViewController())
      naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "채팅", image: #imageLiteral(resourceName: "icons8-chat-bubble"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let settingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: ConfigureViewController())
    let tabBar = UITabBarItem(title: "설정", image: #imageLiteral(resourceName: "icons8-gender-neutral-user"), tag: 0)
    naviVC.navigationBar.prefersLargeTitles = true
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
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
    titleLabel.font = UIFont.NotoSansKRMedium(size: 12)
    titleLabel.textColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    self.navigationItem.titleView = titleLabel
    self.viewControllers = [
     mainViewController,
     historyViewController,
     writerViewController,
     chattingViewController,
     settingViewController
    ]
  }
}
