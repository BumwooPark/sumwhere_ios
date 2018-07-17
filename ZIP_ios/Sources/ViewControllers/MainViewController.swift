//
//  MainViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import expanding_collection
import Floaty
import RxSwift
import RxCocoa
import DZNEmptyDataSet

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
  block(value)
  return value
}

final class MainViewController: ExpandingViewController{
  
  var didUpdateConstraint = false
   fileprivate var cellsIsOpen = [Bool]()
  
  lazy var floaty: Floaty = {
    let floaty = Floaty()
    floaty.addItem(title: "친구 추가", handler: { (item) in
      self.navigationController?.pushViewController(FriendsViewController(), animated: true)
    })
    floaty.addItem(title: "여행 추가")
    
    floaty.items.forEach{
      $0.titleLabel.font = UIFont.BMJUA(size: 13)
    }
    floaty.plusColor = .white
    floaty.buttonColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
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

    self.addRightBarButtonWithImage(#imageLiteral(resourceName: "icons8-menu-48"))
    
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.setNeedsUpdateConstraints()
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
//    return items.count
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: indexPath) as! MainViewCell
    return cell
  }
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? MainViewCell else { return }
    
//    let index = indexPath.row % items.count
//    let info = items[index]
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


