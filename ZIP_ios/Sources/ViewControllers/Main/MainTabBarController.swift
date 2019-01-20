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
//    let naviVC = UINavigationController(rootViewController: MainViewController())
    let naviVC = UINavigationController(rootViewController: MapViewController())
    naviVC.navigationBar.backIndicatorTransitionMaskImage =  #imageLiteral(resourceName: "arrowicon.png")
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "arrowicon.png").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backItem?.title = String()
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "홈", image: #imageLiteral(resourceName: "taskbarHomeNot.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.1019607843, green: 0.1960784314, blue: 0.3333333333, alpha: 1)], for: .selected)
    tabBar.selectedImage = #imageLiteral(resourceName: "taskbarHome.png").withRenderingMode(.alwaysOriginal)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let historyViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MatchRequestViewController())
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let tabBar = UITabBarItem(title: "매칭리스트", image: #imageLiteral(resourceName: "taskbarListNot.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "taskbarList.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.1019607843, green: 0.1960784314, blue: 0.3333333333, alpha: 1)], for: .selected)
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let writerViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MainMatchViewController())
    naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backItem?.title = String()
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    naviVC.navigationBar.largeTitleTextAttributes = [.font: UIFont.NotoSansKRBold(size: 40)]
    let tabBar = UITabBarItem(title: "매칭", image: #imageLiteral(resourceName: "taskbarMacthingNot.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "taskbarMacthing.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.1019607843, green: 0.1960784314, blue: 0.3333333333, alpha: 1)], for: .selected)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let chattingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: ChatListViewController())
    naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
    naviVC.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    naviVC.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysTemplate)
    let tabBar = UITabBarItem(title: "채팅", image: #imageLiteral(resourceName: "taskbarChattingNot.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "taskbarChatting.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.1019607843, green: 0.1960784314, blue: 0.3333333333, alpha: 1)], for: .selected)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let settingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MyPageViewController())
    let tabBar = UITabBarItem(title: "마이페이지", image: #imageLiteral(resourceName: "taskbarMypageNot.png").withRenderingMode(.alwaysOriginal), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "taskbarMypage.png").withRenderingMode(.alwaysOriginal)
    tabBar.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.1019607843, green: 0.1960784314, blue: 0.3333333333, alpha: 1)], for: .selected)
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
