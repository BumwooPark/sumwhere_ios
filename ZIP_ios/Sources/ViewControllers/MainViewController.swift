//
//  MainViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//  메인 페이지 컬랙션뷰

import expanding_collection
import Floaty
import RxSwift
import RxCocoa
import RxDataSources
import DZNEmptyDataSet
import Hero
import SideMenu

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
  block(value)
  return value
}

final class MainViewController: ExpandingViewController{
  
  let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  fileprivate var cellsIsOpen = [Bool]()
  var datas = [TravelModel]()
  
  
  lazy var floaty: Floaty = {
    let floaty = Floaty()
    floaty.addItem(title: "친구 추가", handler: {[weak self] _ in
      self?.navigationController?.pushViewController(FriendsViewController(), animated: true)
    })
    floaty.addItem(title: "여행 추가", handler: {[weak self] _ in
      self?.navigationController?.pushViewController(CreateTravelViewController(), animated: true)
    })
    floaty.items.forEach{
      $0.titleLabel.font = UIFont.BMJUA(size: 13)
    }
    floaty.plusColor = .white
    floaty.buttonColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    return floaty
  }()
  
  override func viewDidLoad() {
    itemSize = CGSize(width: 256, height: 460)
    super.viewDidLoad()
    
    collectionView?.emptyDataSetSource = self
    collectionView?.emptyDataSetDelegate = self
    
    navigationBarSetting()
    heroSetting()
  
    view.backgroundColor = .white
    view.addSubview(self.floaty)
    addGesture(to: collectionView!)
    
    let nib = UINib(nibName: String(describing: MainViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    collectionView?.alwaysBounceHorizontal = true
    connection()
  }
  
  private func navigationBarSetting(){
    
    let titleLabel = UILabel()
    
    let attachment = NSTextAttachment()
    attachment.image = #imageLiteral(resourceName: "logo")
    attachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)
    
    let attributeString = NSAttributedString(attachment: attachment)
    
    let myString = NSMutableAttributedString(string: String())
    myString.append(attributeString)
    myString.append(NSAttributedString(string: "갈래말래",
                                       attributes: [NSAttributedStringKey.font : UIFont.BMJUA(size: 24),
                                                    .foregroundColor: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)]))
    titleLabel.attributedText = myString
    self.navigationItem.titleView = titleLabel
    
    let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: LeftSideMenuViewController())
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    SideMenuManager.default.menuPresentMode = .menuSlideIn
    SideMenuManager.default.menuWidth = 300
    SideMenuManager.default.menuAnimationBackgroundColor = .white
    SideMenuManager.default.menuFadeStatusBar = false
    SideMenuManager.default.menuShadowColor = .black
    
    let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menuOff").withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    leftBarButton.tintColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    self.navigationItem.leftBarButtonItem = leftBarButton
    
    leftBarButton.rx.tap
      .subscribe(onNext: {[weak self] (_) in
        self?.present(menuLeftNavigationController, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    rightBarButton.tintColor = #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1)
    self.navigationItem.rightBarButtonItem = rightBarButton
    
    SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
    SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
  }

  
  private func heroSetting(){
    navigationController?.hero.navigationAnimationType = .fade
    navigationController?.hero.isEnabled = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.setNeedsUpdateConstraints()
  }
  
  //  NetWorking
  private func connection(){
    
    AuthManager.provider
      .request(.myTravel)
      .map(ResultModel<[TravelModel]>.self)
      .asObservable()
      .map{$0.result}
      .filterNil()
      .do(onNext: { [weak self] (models) in
        self?.datas = models
        self?.cellsIsOpen = Array(repeating: false, count: models.count)
      })
      .subscribe(onNext: {[weak self] (models) in
        guard let `self` = self else {return}
        self.collectionView?.reloadData()
        self.cellsIsOpen = Array(repeating: false, count: models.count)
      }).disposed(by: disposeBag)
  }
}


// Constraint
extension MainViewController{
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      
      floaty.snp.makeConstraints { (make) in
        make.right.equalTo(self.view.snp.rightMargin)
        make.bottom.equalToSuperview().inset(80)
        make.height.width.equalTo(70)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension MainViewController{
  fileprivate func addGesture(to view: UIView) {
    let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
      $0.direction = .up
    }
    
    let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
      $0.direction = .down
    }
    view.addGestureRecognizer(upGesture)
    view.addGestureRecognizer(downGesture)
  }
}

extension MainViewController{
  
  @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
    let indexPath = IndexPath(row: currentIndex, section: 0)
    guard let cell = collectionView?.cellForItem(at: indexPath) as? MainViewCell else { return }
    // double swipe Up transition
    if cell.isOpened == true && sender.direction == .up {
      let matchtv = MatchDetailTableViewController(image: (cell.imageView.image) ?? UIImage(),model: cell.item!)
      matchtv.heroID = "destination_\(indexPath.item)"
      navigationController?.pushViewController(matchtv, animated: true)
    }
    
    let open = sender.direction == .up ? true : false
    cell.cellIsOpen(open)
    cellsIsOpen[indexPath.row] = cell.isOpened
  }
  
  override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return datas.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: indexPath) as! MainViewCell
    cell.item = datas[indexPath.item]
    cell.imageView.hero.id = "destination_\(indexPath.item)"
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? MainViewCell else { return }
    cell.cellIsOpen(cellsIsOpen[indexPath.item], animated: false)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? MainViewCell
      , currentIndex == indexPath.row else { return }
    
    if cell.isOpened == false {
      cell.cellIsOpen(true)
    } else {
      let matchtv = MatchDetailTableViewController(image: (cell.imageView.image) ?? UIImage(),model: cell.item!)
      matchtv.heroID = "destination_\(indexPath.item)"
      navigationController?.pushViewController(matchtv, animated: true)
    }
  }
}

extension MainViewController: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "앗! 등록하신 여행이 없네요!!",
                              attributes: [NSAttributedStringKey.font : UIFont.BMJUA(size: 15)])
  }
}

extension MainViewController: DZNEmptyDataSetDelegate{
}


