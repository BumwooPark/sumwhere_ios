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
    itemImage: #imageLiteral(resourceName: "nearby_icon"),
    leftItemImage: nil,
    rightItemImage: nil
  )
  
  let secondItem = YALTabBarItem(
    itemImage: #imageLiteral(resourceName: "profile_icon"),
    leftItemImage: #imageLiteral(resourceName: "edit_icon"),
    rightItemImage: nil
  )
  
  let thirdItem = YALTabBarItem(
    itemImage: #imageLiteral(resourceName: "chats_icon"),
    leftItemImage: #imageLiteral(resourceName: "search_icon"),
    rightItemImage: #imageLiteral(resourceName: "new_chat_icon")
  )
  
  let forthItem = YALTabBarItem(
    itemImage: #imageLiteral(resourceName: "settings_icon"),
    leftItemImage: nil,
    rightItemImage: nil
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
  
  //  lazy var tabBarView: YALFoldingTabBar = {
  //    let tabBar = YALFoldingTabBar(controller: self)
  //    tabBar.dotColor = .red
  //
  //    return tabBar
  //  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .gray
    //    self.tabBarView.
    self.leftBarItems = [firstItem, secondItem]
    self.rightBarItems = [thirdItem, forthItem]
    self.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
    self.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
    self.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
    self.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
    self.tabBarView.backgroundColor = .blue
    self.tabBarView.tabBarColor = .yellow
    self.tabBarView.dotColor = .red
    
    self.view.addSubview(button)
    button.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    button.rx.controlEvent(.touchUpInside)
      .subscribe { (event) in
        KOSession.shared().logoutAndClose(completionHandler: { (status, error) in
          
        })
        
    }
    
  }
}

extension MainTabBarController: YALTabBarDelegate{
  
}

