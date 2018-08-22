//
//  AdViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class AdViewController: UIViewController{
  var didUpdateConstraint = false
  
  var pageView: PageViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    log.info("videdidload")
    
    let one = UIViewController()
    one.view.backgroundColor = .red
    let two = UIViewController()
    two.view.backgroundColor = .blue
    let three = UIViewController()
    three.view.backgroundColor = .yellow
    
    pageView = PageViewController(pages: [one,two,three], spin: true)
    
    addChildViewController(pageView)
    view.addSubview(pageView.view)
    pageView.didMove(toParentViewController: self)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      pageView.view.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
  override func willMove(toParentViewController parent: UIViewController?) {
    super.willMove(toParentViewController: parent)
    log.info("willmove")
  }
  
  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    log.info("didMove")
  }
}
