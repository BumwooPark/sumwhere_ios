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

class RegisterdViewController: UIViewController{
  
  var didUpdateConstraint = false
  var model: TripModel{
    didSet{
      tagViewController.data.accept(model)
    }
  }
  let disposeBag = DisposeBag()
  
  let tagViewController = RegisterdSubviewController()
  
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
    button.setTitle(model.tripType.trip, for: .normal)
    button.titleLabel?.font = UIFont.AppleSDGothicNeoMedium(size: 18)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  lazy var typeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "scheduleMatchIcon.png"), for: .selected) // 계획
    button.setImage(#imageLiteral(resourceName: "onetimematchicon.png"), for: .normal) // 즉흥
    if self.model.trip.matchTypeId == 1{
      button.isSelected = false
    }else {
      button.isSelected = true
    }
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
  
  init(model: TripModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    GetMatchList()
    if let navigationController = navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(collectionView, delay: 50.0)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.isTranslucent = false
    
    self.view.addSubview(tagViewController.view)
    self.addChild(tagViewController)
    self.view.addSubview(collectionView)
    

    navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: titleButton),UIBarButtonItem(customView: typeButton)]
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    
    view.setNeedsUpdateConstraints()
    
    tagViewController.data.accept(model)
    
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
          let vc = ChangeGenderViewController(trip: weakSelf.model.trip)
          vc.completed = {
            weakSelf.tagViewController.data.accept($0)
          }
          weakSelf.present(vc, animated: true, completion: nil)
        }
      }
    }.disposed(by: disposeBag)
    
    GetMatchList()
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    deleteButton.rx.tap
      .bind(onNext: deleteTrip)
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(UserTripJoinModel.self)
      .bind(onNext: selectCard)
      .disposed(by: disposeBag)
  }
  
  func GetMatchList(){
    let api = AuthManager
      .instance
      .provider
      .request(.GetMatchList(tripId: model.trip.id))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[UserTripJoinModel]>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
      
    api.elements()
      .map{[GenericSectionModel<UserTripJoinModel>(items: $0)]}
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    api.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {error in
          log.error(error)
        }
    }.disposed(by: disposeBag)
  }
  
  private func selectCard(model: UserTripJoinModel){
    
    AuthManager.instance
      .provider
      .request(.PossibleMatchCount)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<Int>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {count in
          let popup = PopupDialog(title: "동행을 신청하시겠습니까?",
                                  message:"신청 가능횟수 \(count)",
            buttonAlignment: .horizontal,
            transitionStyle: .zoomIn,
            tapGestureDismissal: true,
            panGestureDismissal: true)
          
          popup.addButtons([Init(CancelButton(title: "취소", action: nil)){ (bt) in
            bt.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            },DefaultButton(title: "확인", action: {
              let request = MatchRequstModel(fromMatchId: model.trip.id, toMatchId: weakSelf.model.trip.id)
              AuthManager.instance.provider.request(.MatchRequest(model: request))
                .filterSuccessfulStatusCodes()
                .subscribe(onSuccess: { (response) in
                  log.info(response)
                }, onError: { (error) in
                  log.error(error)
                }).disposed(by: weakSelf.disposeBag)
            })])
          
          weakSelf.present(popup, animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)

  }
  
  
  private func selectMatchAction(){
    
  }
  
  private func deleteTrip(){
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.titleFont = UIFont.AppleSDGothicNeoRegular(size: 16)
    dialogAppearance.titleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    dialogAppearance.messageFont = UIFont.AppleSDGothicNeoBold(size: 16)
    dialogAppearance.messageColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    let popup = PopupDialog(title: "여행을 삭제하시겠습니까?", message: "\(model.tripType.trip)",buttonAlignment: .horizontal,transitionStyle: .zoomIn,
                            tapGestureDismissal: true,
                            panGestureDismissal: true)
    
    
    popup.addButtons([Init(CancelButton(title: "취소", action: nil)){ (bt) in
      bt.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
      },DefaultButton(title: "확인", action: deleteAction)])
    
    self.present(popup, animated: true, completion: nil)
  }
  
  
  private func deleteAction(){
    AuthManager.instance.provider.request(.deleteTrip(tripId: model.trip.id))
      .filterSuccessfulStatusCodes()
      .subscribe(onSuccess: {[weak self] (response) in
        AlertType.JDStatusBar.getInstance().show(isSuccess: true, message: "삭제 되었습니다.")
        (self?.navigationController as? TripProxyController)?.checkUserRegisterd()
      }) { (error) in
        log.error(error)
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
}
