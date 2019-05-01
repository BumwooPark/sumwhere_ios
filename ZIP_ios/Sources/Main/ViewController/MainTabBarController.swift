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
import RxSwift
import RxCocoa

class MainTabBarController: UITabBarController{
  
  private let disposeBag = DisposeBag()

  lazy var mainViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: NewMainViewController())
    
    naviVC.navigationBar.backIndicatorTransitionMaskImage =  #imageLiteral(resourceName: "arrowicon.png")
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "arrowicon.png").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backItem?.title = String()
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "홈", image: #imageLiteral(resourceName: "home.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.3725490196, green: 0.5607843137, blue: 1, alpha: 1)], for: .selected)
    tabBar.selectedImage = #imageLiteral(resourceName: "home.png").withRenderingMode(.alwaysOriginal)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let historyViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MatchHistoryViewController())
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "검색", image: #imageLiteral(resourceName: "search.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "search.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.3725490196, green: 0.5607843137, blue: 1, alpha: 1)], for: .selected)
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let writerViewController: UINavigationController = {
    let naviVC = TripProxyController()
    naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backItem?.title = String()
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "등록", image: #imageLiteral(resourceName: "add.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "add.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.3725490196, green: 0.5607843137, blue: 1, alpha: 1)], for: .selected)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let chattingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: ChatListViewController())
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "page1.png").withRenderingMode(.alwaysTemplate)
    let tabBar = UITabBarItem(title: "추천여행", image: #imageLiteral(resourceName: "page1.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "taskbarChatting.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.3725490196, green: 0.5607843137, blue: 1, alpha: 1)], for: .selected)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let settingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MyPageViewController())
    let tabBar = UITabBarItem(title: "마이페이지", image: #imageLiteral(resourceName: "my.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "my.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.3725490196, green: 0.5607843137, blue: 1, alpha: 1)], for: .selected)
    naviVC.navigationBar.backIndicatorTransitionMaskImage =  #imageLiteral(resourceName: "arrowicon.png")
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "arrowicon.png").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backItem?.title = String()
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.shadowImage = UIImage()
    
    let titleLabel = UILabel()
    titleLabel.text = "갈래말래"
    titleLabel.font = UIFont.AppleSDGothicNeoBold(size: 12)
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
