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
  
  private let backImageView: UIImageView = UIImageView()
  
  private let advertiseView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .white
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.NanumBarunGothicUltraLight(size: 22)
    label.textColor = .white
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let subTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.NanumBarunGothicLight(size: 14)
    label.textColor = .white
    return label
  }()
  
  private let headerView = MainHeaderView()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backImageView)
    view.addSubview(advertiseView)
    view.addSubview(titleLabel)
    view.addSubview(subTitle)
    
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
      .startWith(0)
      .map{_ in data}
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> ([Background]) -> Void in
        return {data in
          let randNumber = Int.random(in: 0..<data.count)
//          let size = (data.count - 1)
          KingfisherManager.shared.retrieveImage(with: URL(string: data[randNumber].image)!, completionHandler: { (result) in
            do{
            let image = try result.get().image
              UIView.transition(with: weakSelf.backImageView, duration: 1, options: .transitionCrossDissolve, animations: {
                weakSelf.backImageView.image = image
                weakSelf.titleLabel.text = data[randNumber].title
                weakSelf.subTitle.text = data[randNumber].subTitle
              }, completion: nil)
            }catch let error{
              log.error(error)
            }
          })
//          if weakSelf.currentIndex == size {
//            weakSelf.currentIndex = 0
//          }else{
//            weakSelf.currentIndex += 1
//          }
          
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
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-100)
      }
      
      subTitle.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(20)
        make.centerX.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
