//
//  MainViewController.swift
//  ZIP_ios
//
//  Created by bumwoopark on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//  메인 페이지 컬랙션뷰


import RxSwift
import RxCocoa
import RxGesture
import RxDataSources
import DZNEmptyDataSet
import Hero
import SnapKit

final class MainViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  var foreGround = false
  
  var pageContainerInitialHeight = CGFloat()
  var topConstraint: Constraint?
  var containerViewHeight: Constraint?
  var topAnchorValue: CGFloat = 0
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<MainViewModel>(configureCell: {ds, cv, idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainCollectionCell.self), for: idx) as! MainCollectionCell
    cell.item = item
    return cell
  },configureSupplementaryView: {ds, cv, kind, idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: MainCollectionHeaderView.self), for: idx) as! MainCollectionHeaderView
    view.titleLabel.text = ds.sectionModels[idx.section].header
    return view
  })
  
  let datas = BehaviorRelay<[MainViewModel]>(value: [])
  
  
  private let advertiseViewController = AdViewController()
  
  private let customRightButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "icons8-key-2-24"), for: .normal)
    button.setTitle("33", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.NotoSansKRBold(size: 17)
    return button
  }()
  
  let alertButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "icons8-notification-24"), for: .normal)
    return button
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 250)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
    layout.minimumLineSpacing = 20
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: String(describing: MainCollectionCell.self))
    collectionView.register(MainCollectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: MainCollectionHeaderView.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  private let titleLabel: UILabel = {
    let titleLabel = UILabel()
    let attachment = NSTextAttachment()
    attachment.image = #imageLiteral(resourceName: "logo")
    attachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)
    let attributeString = NSAttributedString(attachment: attachment)
    
    let myString = NSMutableAttributedString(string: String())
    myString.append(attributeString)
    myString.append(NSAttributedString(string: "갈래말래",
                                       attributes: [NSAttributedStringKey.font : UIFont.NotoSansKRMedium(size: 24),
                                                    .foregroundColor: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)]))
    titleLabel.attributedText = myString
    return titleLabel
  }()
  
  private let contentView = UIView()
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    return scrollView
  }()
  
  override func loadView() {
    super.loadView()
    let titleLabel = UILabel()
    let attachment = NSTextAttachment()
    attachment.image = #imageLiteral(resourceName: "logo")
    attachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)
    
    let attributeString = NSAttributedString(attachment: attachment)
    let myString = NSMutableAttributedString(string: String())
    myString.append(attributeString)
    myString.append(NSAttributedString(string: "갈래말래",
                                       attributes: [NSAttributedStringKey.font : UIFont.NotoSansKRMedium(size: 24),
                                                    .foregroundColor: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)]))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customRightButton)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: alertButton)
    titleLabel.attributedText = myString
    self.navigationItem.titleView = titleLabel
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Observable<Int>.interval(4, scheduler: MainScheduler.instance)
      .filter({[unowned self] (_) -> Bool in
        return self.foreGround
      })
      .subscribeNext(weak: self, { (retainSelf) -> (Int) -> Void in
        return { _ in
          retainSelf.advertiseViewController.pageView.scrollToAutoForward()
        }
      }).disposed(by: disposeBag)
    
    self.navigationController?.navigationBar.topItem?.title = String()

    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    addChildViewController(advertiseViewController)
    advertiseViewController.didMove(toParentViewController: self)
    contentView.addSubview(collectionView)
    contentView.addSubview(advertiseViewController.view)
    pageContainerInitialHeight = advertiseViewController.view.frame.height
    
    view.setNeedsUpdateConstraints()
    collectionView.contentInset = UIEdgeInsets(top: 180, left: 0, bottom: 50, right: 0)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    Observable.just([MainViewModel(header: "추천 여행지", items: [
      MainModel(title: "인기 급상승 \n여행지!", detail:"여행자 필수 구독!" ,image: #imageLiteral(resourceName: "bridge")),
      MainModel(title: "최다 등록\n여행지!", detail:"핫한 10개 도시", image: #imageLiteral(resourceName: "tower")),
      MainModel(title: "최다 매칭\n여행지!", detail:"혼행 보단 동행!",image: #imageLiteral(resourceName: "bridge2"))])])
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    scrollView.rx.didScroll
      .subscribe(weak: self) { (retainSelf) -> (Event<()>) -> Void in
        return { _ in
          
          retainSelf.topAnchorValue = retainSelf.scrollView.contentOffset.y
          if retainSelf.topAnchorValue > 0 || retainSelf.topAnchorValue ==  -retainSelf.topAnchorValue{
            retainSelf.topAnchorValue = 0
          }
          retainSelf.topConstraint?.update(inset: retainSelf.topAnchorValue)
        }
    }.disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribeNext(weak: self) { (retainSelf) -> (IndexPath) -> Void in
        return { idx in
          switch idx.item{
          case 0:
            retainSelf.navigationController?.pushViewController(TopTripViewController(), animated: true)
          case 1:
            retainSelf.navigationController?.pushViewController(TopTripViewController(), animated: true)
          case 2:
            retainSelf.navigationController?.pushViewController(TopTripViewController(), animated: true)
          default:
            break
          }
        }
    }.disposed(by: disposeBag)
    
    collectionView.layoutIfNeeded()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    log.info("viewWillAppear")
    foreGround = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    log.info("viewWillDisappear")
    foreGround = false
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerViewHeight?.update(offset: collectionView.contentSize.height + 180)
    scrollView.contentSize = CGSize(width: collectionView.contentSize.width, height: collectionView.contentSize.height + 180)
    log.info(advertiseViewController.view.frame.origin.y)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalTo(self.view.safeAreaLayoutGuide)
      }
      
      contentView.snp.makeConstraints { (make) in
        make.leading.trailing.top.bottom.equalToSuperview()
        make.centerX.equalToSuperview()
        containerViewHeight = make.height.equalToSuperview().priority(250).constraint
      }
      
      advertiseViewController.view.snp.makeConstraints { (make) in
        topConstraint = make.top.equalTo(topAnchorValue).constraint
        make.left.right.equalTo(scrollView)
        make.height.equalTo(180)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
