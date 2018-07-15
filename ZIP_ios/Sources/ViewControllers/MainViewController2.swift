//
//  MainViewController2.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import expanding_collection

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
  block(value)
  return value
}

class MainViewController2: ExpandingViewController{
  var items: [String] = ["1","2","3"]
  fileprivate var cellsIsOpen = [Bool]()
  override func viewDidLoad() {
    itemSize = CGSize(width: 256, height: 460)
    super.viewDidLoad()
    view.backgroundColor = .white
    addGesture(to: collectionView!)
    let nib = UINib(nibName: String(describing: MainViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    cellsIsOpen = Array(repeating: false, count: items.count)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()

    self.addRightBarButtonWithImage(#imageLiteral(resourceName: "icons8-menu-48"))
    
  }
}

extension MainViewController2{
  fileprivate func addGesture(to view: UIView) {
    let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController2.swipeHandler(_:)))) {
      $0.direction = .up
    }
    
    let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController2.swipeHandler(_:)))) {
      $0.direction = .down
    }
    view.addGestureRecognizer(upGesture)
    view.addGestureRecognizer(downGesture)
  }
}

extension MainViewController2{
  
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
    return items.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: indexPath) as! MainViewCell
    return cell
  }
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? MainViewCell else { return }
    
    let index = indexPath.row % items.count
    let info = items[index]
    cell.cellIsOpen(cellsIsOpen[index], animated: false)
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
