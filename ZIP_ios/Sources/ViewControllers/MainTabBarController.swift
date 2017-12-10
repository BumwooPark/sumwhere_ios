
import UIKit



class MainTabBarController: UITabBarController{
  
  let feedViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: FeedViewController())
    let tabBar = UITabBarItem(title: "피드", image: #imageLiteral(resourceName: "chats_icon"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let writerViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: WriteViewController())
    let tabBar = UITabBarItem(title: "글쓰기", image: #imageLiteral(resourceName: "edit_icon"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let mainViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: MainViewController())
    let tabBar = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icons8-prop_plane"), tag: 0)
    tabBar.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let searchPersonViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: UIViewController())
    let tabBar = UITabBarItem(title: "모으기", image: #imageLiteral(resourceName: "search_icon"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  
  let settingViewController: UINavigationController = {
    let naviVC = UINavigationController(rootViewController: UIViewController())
    let tabBar = UITabBarItem(title: "설정", image: #imageLiteral(resourceName: "profile_icon"), tag: 0)
    naviVC.tabBarItem = tabBar
    return naviVC
  }()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.viewControllers = [
      feedViewController, writerViewController, mainViewController
      , searchPersonViewController, settingViewController
    ]
  }
}
