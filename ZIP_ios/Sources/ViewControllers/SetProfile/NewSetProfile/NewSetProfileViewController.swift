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
  var viewModel: ProfileViewModel?{get set}
  var completeSubject: PublishSubject<Void>? {get set}
}

class NewSetProfileViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let completeSubject = PublishSubject<Void>()
  private let viewModel = ProfileViewModel()
  
  
  let progressView: UIProgressView = {
    let progress = UIProgressView()
    progress.trackTintColor = #colorLiteral(red: 0.8431372549, green: 0.862745098, blue: 0.8745098039, alpha: 1)
    progress.progressTintColor = #colorLiteral(red: 0.1843137255, green: 0.5568627451, blue: 1, alpha: 1)
    return progress
  }()
  
  var childs:[UIViewController & ProfileCompletor] = [FirstViewController(),
                                                      NickNameViewController(),
                                                      GenderViewController(),
                                                      AgeViewController(),
                                                      ProfileImageViewController(),
                                                      CharacterViewController(),
                                                      InterestViewController()]
  
  var didUpdateConstraint = false
  lazy var pageView = PageViewController(pages: childs, spin: false)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pageView.isPagingEnabled = false
    view.backgroundColor = .white
    addChildViewController(pageView)
    view.addSubview(pageView.view)
    view.addSubview(progressView)
    pageView.didMove(toParentViewController: self)
    view.setNeedsUpdateConstraints()
    
    pageView.currentIndexSubject
      .map { [unowned self] (current) -> Float in
      let percent = (Float(current) / Float(self.childs.count))
      return percent
      }.subscribeNext(weak: self) { (weakSelf) -> (Float) -> Void in
        return {progress in
          log.info(progress)
          weakSelf.progressView.setProgress(progress, animated: true)
        }
    }.disposed(by: disposeBag)
    
    
    for i in 0..<childs.count{
      childs[i].completeSubject = self.completeSubject
      childs[i].viewModel = self.viewModel
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
      
      progressView.snp.makeConstraints { (make) in
        make.left.right.top.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(2)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
