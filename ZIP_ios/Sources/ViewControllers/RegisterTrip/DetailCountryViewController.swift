//
//  DetailCountryViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 09/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import PreviewTransition
import RxDataSources
import RxCocoa
import RxSwift

class DetailCountryViewController: PTDetailViewController{
  
  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  private let selectAction = PublishRelay<CountryTripPlace>()
  private let API: Observable<Event<[CountryTripPlace]>>

  private let datas = BehaviorRelay<[GenericSectionModel<CountryTripPlace>]>(value: [])
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<CountryTripPlace>>(
    configureCell: {[weak self] ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: DetailTripCell.self), for: idx) as! DetailTripCell
    cell.item = item
    cell.tag = idx.row
    cell.selectAction = self?.selectAction
    return cell
    })
  
  lazy var backButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "arrowicon.png")
    button.title = "국가 선택"
    self.navigationItem.leftBarButtonItem = button
    return button
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 400)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(DetailTripCell.self,
                            forCellWithReuseIdentifier: String(describing: DetailTripCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    collectionView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    collectionView.alpha = 0
    return collectionView
  }()
  
  init(model: Country) {
    self.API = AuthManager.instance.provider
      .request(.tripPlaces(countryId: model.id))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[CountryTripPlace]>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.backgroundColor = .white
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = .white
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.backgroundColor = .clear
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = .clear
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    
    backButton
      .rx
      .tap
      .bind(onNext: popViewController)
      .disposed(by: disposeBag)
    
    API.elements()
      .map{[GenericSectionModel<CountryTripPlace>(items: $0)]}
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    API.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {error in
          log.error(error)
        }
      }.disposed(by: disposeBag)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    selectAction
      .bind(onNext: pushViewController)
      .disposed(by: disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.5) {[unowned self] in
        self.collectionView.alpha = 1
      }
    }
  }
  
  private func pushViewController(place: CountryTripPlace){
    tripRegisterContainer.register(CountryTripPlace.self) { _ in place }
    self.navigationController?.pushViewController(InsertPlanViewController(), animated: true)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
