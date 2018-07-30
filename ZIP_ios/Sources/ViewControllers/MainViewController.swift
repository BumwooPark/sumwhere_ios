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
    
    view.backgroundColor = .white
    view.addSubview(self.floaty)
    addGesture(to: collectionView!)
    let nib = UINib(nibName: String(describing: MainViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    //    cellsIsOpen = Array(repeating: false, count: items.count)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    collectionView?.alwaysBounceHorizontal = true
    self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "menuOff"))
    self.addRightBarButtonWithImage(#imageLiteral(resourceName: "search"))
    connection()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.setNeedsUpdateConstraints()
  }
  
  //  NetWorking
  private func connection(){
    
    
    
//    AuthManager.provider
//      .request(.travelGetAll(order: "desc", sortby: "id", skipCount: 0))
    AuthManager.provider
      .request(.myTravel)
      .map(ResultModel<[TravelModel]>.self)
      .asObservable()
      .map{$0.result}
      .filterNil()
      .do(onNext: { [weak self] (models) in
        self?.datas = models
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
        make.bottom.equalToSuperview().inset(100)
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
      pushToViewController(MainTableViewController())
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
    return cell
  }
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? MainViewCell else { return }
    
    //    cell.cellIsOpen(cellsIsOpen[index], animated: false)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? MainViewCell
      , currentIndex == indexPath.row else { return }
    
    if cell.isOpened == false {
      cell.cellIsOpen(true)
    } else {
      pushToViewController(MainTableViewController())
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


