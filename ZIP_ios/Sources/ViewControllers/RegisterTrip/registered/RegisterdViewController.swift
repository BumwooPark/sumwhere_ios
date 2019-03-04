//
//  RegisterdViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 25/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import AMScrollingNavbar
import TagListView
import PopupDialog
import Swinject
import NVActivityIndicatorView

class RegisterdViewController: UIViewController{
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()

  lazy var viewModel: RegisterdTripViewModel = RegisterdTripViewModel()
  
  private let tagViewController = RegisterdSubviewController()
  
  private let datas = BehaviorRelay<[GenericSectionModel<UserTripJoinModel>]>(value: [])
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<UserTripJoinModel>>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MatchResultCell.self), for: idx) as! MatchResultCell
    cell.item = item
    return cell
  })
  
  private let deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("일정 삭제", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1), for: .normal)
    return button
  }()
  
  lazy var titleButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "locationIcon.png"), for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 18)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  lazy var typeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "scheduleMatchIcon.png"), for: .selected) // 계획
    button.setImage(#imageLiteral(resourceName: "onetimematchicon.png"), for: .normal) // 즉흥
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    return button
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 68, height: 413)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MatchResultCell.self, forCellWithReuseIdentifier: String(describing: MatchResultCell.self))
    collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    collectionView.alwaysBounceVertical = true
    collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    return collectionView
  }()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let navigationController = navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(collectionView, delay: 50.0)
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.stopFollowingScrollView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NVActivityIndicatorPresenter
      .sharedInstance
      .sumwhereStart()
   
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.isTranslucent = false
    
    self.view.addSubview(tagViewController.view)
    self.addChild(tagViewController)
    self.view.addSubview(collectionView)
  
    navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: titleButton),UIBarButtonItem(customView: typeButton)]
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    
    view.setNeedsUpdateConstraints()
    
    if let model = tripRegisterContainer.resolve(TripModel.self, name: "own"){
      typeButton.isSelected = model.trip.matchTypeId != 1
      titleButton.setTitle(model.tripPlace.trip, for: .normal)
      tagViewController.data.accept(model)
    }
    
    
    tagViewController
      .selectAction
      .subscribeNext(weak: self) { (weakSelf) -> (TripSelectorType) -> Void in
      return {type in
        
        switch type {
        case .comment:
          break
//          let vc = ChangeConceptViewController(trip: weakSelf.model.trip)
//          vc.completed = {
//            weakSelf.tagViewController.data.accept($0)
//          }
//          weakSelf.present(vc, animated: true, completion: nil)
        case .date:
          break
        case .gender:
//          let vc = ChangeGenderViewController(trip: weakSelf.model.trip)
//          vc.completed = {
//            weakSelf.tagViewController.data.accept($0)
//          }
//          weakSelf.present(vc, animated: true, completion: nil)
          break
        }
      }
    }.disposed(by: disposeBag)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    bind()
  }
  
  private func bind(){
    
    collectionView.rx.modelSelected(UserTripJoinModel.self)
      .subscribeNext(weak: self) { (weakSelf) -> (UserTripJoinModel) -> Void in
        return {model in
          tripRegisterContainer.register(Trip.self, name: "target", factory: { _ in model.trip })
          let vc = ProfileViewController(id: model.user.id)
          weakSelf.present(vc, animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
    
    viewModel.outputs
      .matchList
      .elements()
      .map{[GenericSectionModel<UserTripJoinModel>(items: $0)]}
      .do(onNext: {(_) in
        NVActivityIndicatorPresenter.sharedInstance.sumwhereStop()
      })
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    deleteButton.rx.tap
      .bind(onNext: viewModel.inputs.deleteTrip)
      .disposed(by: disposeBag)
    
    viewModel.outputs
      .deleteSuccess
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          (weakSelf.navigationController as? TripProxyController)?.checkUserRegisterd()
        }
    }.disposed(by: disposeBag)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      tagViewController.view.snp.makeConstraints { (make) in
        make.top.equalTo((self.navigationController?.navigationBar.snp.bottom)!)
        make.left.right.equalToSuperview()
        make.height.equalTo(50)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview()
        make.top.equalTo(tagViewController.view.snp.bottom)
        make.bottom.equalTo(self.view.safeAreaLayoutGuide)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
  open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.showNavbar(animated: true)
    }
    return true
  }
}
