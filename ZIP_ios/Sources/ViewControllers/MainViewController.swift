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
import Hero
import SnapKit
import Moya
import NVActivityIndicatorView

final class MainViewController: UIViewController, NVActivityIndicatorViewable{
  
  let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  var foreGround = false
  
  var pageContainerInitialHeight = CGFloat()
  var topConstraint: Constraint?
  var containerViewHeight: Constraint?
  var topAnchorValue: CGFloat = 0

  let viewModel = MainViewModel()
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<MainCellViewModel>(configureCell: {ds, cv, idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainCollectionCell.self), for: idx) as! MainCollectionCell
    cell.item = item
    return cell
  },configureSupplementaryView: {ds, cv, kind, idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: MainCollectionHeaderView.self), for: idx) as! MainCollectionHeaderView
    view.titleLabel.text = ds.sectionModels[idx.section].header
    return view
  })
  
  let datas = BehaviorRelay<[MainCellViewModel]>(value: [])
  
  private let advertiseViewController: AdViewController = {
    let vc = AdViewController()
    vc.view.layer.cornerRadius = 15
    vc.view.layer.masksToBounds = true
    return vc
  }()
  
  private let customRightButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "icons8-key-2-24") , for: .normal)
//    button.setTitle("33", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.NotoSansKRBold(size: 17)
    return button
  }()
  
  let alertButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "galmalicon.png"), for: .normal)
    return button
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 167)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 103)
    layout.minimumLineSpacing = 21
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: String(describing: MainCollectionCell.self))
    collectionView.register(MainCollectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: MainCollectionHeaderView.self))
    collectionView.contentInset = UIEdgeInsets(top: 180, left: 0, bottom: 0, right: 0)
    collectionView.backgroundColor = .clear
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
                                       attributes: [NSAttributedString.Key.font : UIFont.NotoSansKRMedium(size: 24),
                                                    .foregroundColor: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)]))
    titleLabel.attributedText = myString
    return titleLabel
  }()
  
  private let contentView = UIView()
  private let footerView = MainFooterView.loadXib(nibName: "MainFooterView") as! MainFooterView
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .clear
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customRightButton)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: alertButton)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    startAnimating(CGSize(width: 50, height: 50), type: .circleStrokeSpin, color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1),fadeInAnimation: NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    
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
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    addChild(advertiseViewController)
    advertiseViewController.didMove(toParent: self)
    contentView.addSubview(collectionView)
    contentView.addSubview(advertiseViewController.view)
    contentView.addSubview(footerView)
    pageContainerInitialHeight = advertiseViewController.view.frame.height

    view.setNeedsUpdateConstraints()
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    viewModel
      .userAPI
      .elements()
      .flatMapLatest { (model) -> Observable<[MainCellViewModel]> in
        let name = model.result?.nickname ?? String()
        return Observable.just([MainCellViewModel(header: "\(name)님을\n위한 갈래말래의 추천 여행지", items: [
          MainModel(title: "01\n인기 급상승 여행지!", detail:"여행자 필수 구독!" ,image: #imageLiteral(resourceName: "bridge")),
          MainModel(title: "02\n최다 등록 여행지!", detail:"핫한 10개 도시", image: #imageLiteral(resourceName: "tower")),
          MainModel(title: "최다 매칭 여행지!", detail:"혼행 보단 동행!",image: #imageLiteral(resourceName: "bridge2")),
          MainModel(title: "즉흥 여행지!", detail: "즉흥으로 떠나자!", image: #imageLiteral(resourceName: "bridge2"))])])
      }.do(onNext: {[weak self] (_) in
        self?.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
      }).bind(to: datas)
      .disposed(by: disposeBag)
    
    viewModel
      .userAPI
      .elements()
      .subscribeNext(weak: self, { (weakSelf) -> (ResultModel<UserModel>) -> Void in
        return {model in
          weakSelf.customRightButton.setTitle("\(model.result?.point ?? 0)", for: .normal)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel
      .userAPI
      .errors()
      .subscribe(onNext: { (error) in
        (error as? MoyaError)?.GalMalErrorHandler()
      }).disposed(by: disposeBag)
    
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
          case 3:
            retainSelf.navigationController?.pushViewController(FastTripViewController(), animated: true)
          default:
            break
          }
        }
    }.disposed(by: disposeBag)
    
    collectionView.layoutIfNeeded()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    foreGround = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    foreGround = false
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerViewHeight?.update(offset: collectionView.contentSize.height - 180)
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalTo(self.view.safeAreaLayoutGuide)
      }
      
      contentView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
        make.width.equalTo(self.view)
        containerViewHeight = make.height.equalTo(self.view).constraint
      }
      
      footerView.snp.makeConstraints { (make) in
        make.bottom.left.right.equalToSuperview()
        make.height.equalTo(144)
      }
      
      advertiseViewController.view.snp.makeConstraints { (make) in
        topConstraint = make.top.equalTo(topAnchorValue).constraint
        make.left.right.equalToSuperview().inset(9)
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
