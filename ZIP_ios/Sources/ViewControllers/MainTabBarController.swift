//
//  MainTabBarController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import FoldingTabBar

class MainTabBarController: YALFoldingTabBarController {
  
  let firstItem = YALTabBarItem(
    itemImage: #imageLiteral(resourceName: "chats_icon"),
    leftItemImage: #imageLiteral(resourceName: "profile_icon"),
    rightItemImage: #imageLiteral(resourceName: "profile_icon")
  )
  
  let secondItem = YALTabBarItem(
    itemImage: #imageLiteral(resourceName: "profile_icon"),
    leftItemImage: #imageLiteral(resourceName: "edit_icon"),
    rightItemImage: #imageLiteral(resourceName: "profile_icon")
  )
  
  let thirdItem = YALTabBarItem(
    itemImage: #imageLiteral(resourceName: "chats_icon"),
    leftItemImage: #imageLiteral(resourceName: "search_icon"),
    rightItemImage: #imageLiteral(resourceName: "new_chat_icon")
  )
  
  let forthItem = YALTabBarItem(
    itemImage: #imageLiteral(resourceName: "settings_icon"),
    leftItemImage: #imageLiteral(resourceName: "profile_icon"),
    rightItemImage: #imageLiteral(resourceName: "profile_icon")
  )
  
  let feedVC: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: FeedViewController())
    naviVC.tabBarItem = UITabBarItem(title: "피드", image: nil, tag: 0)
    return naviVC
  }()
  
  let button: UIButton = {
    let button = UIButton()
    button.setTitle("로그아웃", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    return button
  }()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.leftBarItems = [firstItem, secondItem]
    self.rightBarItems = [thirdItem, forthItem]
    self.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
    self.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
    self.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
    self.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
    self.centerButtonImage = UIImage(named:"plus_icon")!
    self.tabBarView.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0, blue: 149.0/255.0, alpha: 1)
    self.tabBarView.tabBarColor = UIColor(red: 72.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1)
    
    self.view.addSubview(button)
    button.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    button.rx.controlEvent(.touchUpInside)
      .subscribe { (event) in
//        UserDefaults.standard.set(false, forKey: "login")
        KOSession.shared().logoutAndClose(completionHandler: { (status, error) in
          
        })
        
    }
    
  }
}

extension MainTabBarController: YALTabBarDelegate{
  
}

