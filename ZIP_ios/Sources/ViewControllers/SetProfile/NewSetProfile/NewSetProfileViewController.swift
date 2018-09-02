//
//  NewSetProfileViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

class NewSetProfileViewController: UIViewController{
  
  var didUpdateConstraint = false
  let pageView = PageViewController(pages: [FirstViewController(),
                                            GenderViewController(),
                                            ProfileImageViewController(),
                                            NickNameViewController()], spin: false)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addChildViewController(pageView)
    view.addSubview(pageView.view)
    pageView.didMove(toParentViewController: self)
    view.setNeedsUpdateConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      pageView.view.snp.makeConstraints { (make) in
        make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
