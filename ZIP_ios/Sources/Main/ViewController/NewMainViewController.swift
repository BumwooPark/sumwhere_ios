//
//  NewMainViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 04/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import MXParallaxHeader
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import Kingfisher

final class NewMainViewController: UIViewController {
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  private let viewModel: MainTypes = MainViewModel()
  private var currentIndex = 0
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }

  private let menuButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: #imageLiteral(resourceName: "menu.png").withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    button.tintColor = .white
    return button
  }()
  
  private let backImageView: UIImageView = {
    var imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "imgMain01.png")
    return imageView
  }()
  
  private let advertiseView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .white
    return imageView
  }()
  
  private let headerView = MainHeaderView()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backImageView)
    view.addSubview(advertiseView)
    
    
    
//    view = collectionView
    self.navigationItem.rightBarButtonItem = menuButton
    bind()
    view.setNeedsUpdateConstraints()
  }
  
  func bind(){
    
    viewModel.outputs
      .eventDatas
      .map{[GenericSectionModel<EventModel>(items: $0)]}
      .bind(to: headerView.datas)
      .disposed(by: disposeBag)
    
    viewModel.outputs
      .backgroundDatas
      .filter{$0.count > 0}
      .bind(onNext: backgroundChange)
      .disposed(by: disposeBag)
  }
  
  private func backgroundChange(data: [Background]){
    Observable<Int>.interval(10, scheduler: MainScheduler.instance)
      .map{_ in data}
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> ([Background]) -> Void in
        return {data in
          let size = (data.count - 1)
          KingfisherManager.shared.retrieveImage(with: URL(string: data[weakSelf.currentIndex].image)!, completionHandler: { (result) in
            do{
            let image = try result.get().image
              UIView.transition(with: weakSelf.backImageView, duration: 1, options: .transitionCrossDissolve, animations: {
                weakSelf.backImageView.image = image
              }, completion: nil)
            }catch let error{
              log.error(error)
            }
          })
          if weakSelf.currentIndex == size {
            weakSelf.currentIndex = 0
          }else{
            weakSelf.currentIndex += 1
          }
          
        }
      }.disposed(by: disposeBag)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      
      backImageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      advertiseView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(10)
        make.height.equalTo(67)
        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
  
}
