//
//  TripViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 10..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import BubbleTransition
import RxSwift
import RxCocoa
import RxDataSources

class TripViewController: UIViewController{
  
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  private let viewModel = TripViewModel()
  
  let transition = BubbleTransition()
  let interactiveTransition = BubbleInteractiveTransition()
  
  let destViewController = CreateTripViewController()
  private let addButton: UIButton = {
    let button = UIButton()
    button.setTitle("+", for: .normal)
    button.layer.cornerRadius = 30
    button.clipsToBounds = true 
    button.backgroundColor = #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)
    return button
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    return scrollView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "매칭할 티켓을 선택해 보세요."
    label.font = UIFont.BMJUA(size: 30)
    label.textAlignment = .center
    return label
  }()
  
  private let datas = BehaviorRelay<[MyTripViewModel]>(value: [])
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<MyTripViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: TripTicketCell.self), for: idx) as! TripTicketCell
    return cell
  })
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: 339, height: 175)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(TripTicketCell.self, forCellWithReuseIdentifier: String(describing: TripTicketCell.self))
    collectionView.backgroundColor = .white
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
    view.addSubview(scrollView)
    view.addSubview(addButton)
    scrollView.addSubview(titleLabel)
    scrollView.addSubview(collectionView)
    scrollView.contentInsetAdjustmentBehavior = .never
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    view.setNeedsUpdateConstraints()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    destViewController.transitioningDelegate = self
    destViewController.modalPresentationStyle = .custom
    interactiveTransition.attach(to: destViewController)
    
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    viewModel.api
      .map{$0.result}
      .filterNil()
      .map{[MyTripViewModel(items: $0)]}
      .catchErrorJustReturn([])
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    addButton.rx.tap
      .subscribe {[unowned self] (_) in
        self.present(self.destViewController, animated: true, completion: nil)
      }.disposed(by: disposeBag)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.contentSize =  CGSize(width: collectionView.contentSize.width, height: collectionView.contentSize.height + 300)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      addButton.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.height.width.equalTo(60)
        make.bottom.equalToSuperview().inset(80)
      }
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(20)
        make.centerX.equalToSuperview()
        make.height.equalTo(60)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.left.equalTo(view.snp.left)
        make.right.equalTo(view.snp.right)
        make.bottom.equalTo(view.snp.bottom)
        make.top.equalTo(titleLabel.snp.bottom)
      }
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension TripViewController: UIViewControllerTransitioningDelegate{
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = addButton.center
    transition.bubbleColor = addButton.backgroundColor!
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = addButton.center
    transition.bubbleColor = addButton.backgroundColor!
    return transition
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactiveTransition
  }
}
