//
//  NewSetProfileViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa

protocol ProfileCompletor {
  var completeSubject: PublishSubject<Void>? {get set}
}

class NewSetProfileViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let completeSubject = PublishSubject<Void>()
  
  var childs:[UIViewController & ProfileCompletor] = [FirstViewController(),
                                                      NickNameViewController(),
                                                      GenderViewController(),
                                                      AgeViewController(),
                                                      ProfileImageViewController(),
                                                      CharacterViewController()]
  
  var didUpdateConstraint = false
  lazy var pageView = PageViewController(pages: childs, spin: false)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pageView.isPagingEnabled = false
    view.backgroundColor = .white
    addChildViewController(pageView)
    view.addSubview(pageView.view)
    pageView.didMove(toParentViewController: self)
    view.setNeedsUpdateConstraints()
    
    for i in 0..<childs.count{
      childs[i].completeSubject = self.completeSubject
    }
    
    completeSubject
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.pageView.scrollToAutoForward()
        }
    }.disposed(by: disposeBag)
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
