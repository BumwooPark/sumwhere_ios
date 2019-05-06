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

final class NewMainViewController: UIViewController {
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  private let viewModel: MainTypes = MainViewModel()
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }

  private let menuButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: #imageLiteral(resourceName: "menu.png").withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    button.tintColor = .white
    return button
  }()
  
  private let backImageView: UIImageView = {
    let imageView = UIImageView()
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
      .flatMap {Observable.from($0)}
      .
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
