//
//  SelectMatchViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 11..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import expanding_collection
import RxSwift
import RxCocoa
import DZNEmptyDataSet

enum MatchType: String{
  case relationship = "이성 매칭"
  case fit = "맞춤 매칭"
  case gps = "주변 여행자 매칭"
  case transfer = "운송 매칭"
  
  var images: UIImage{
    get{
      switch self{
      case .relationship:
        return #imageLiteral(resourceName: "relationship")
      case .fit:
        return #imageLiteral(resourceName: "fit")
      case .transfer:
        return #imageLiteral(resourceName: "transfer")
      case .gps:
        return #imageLiteral(resourceName: "gps")
      }
    }
  }
  
}

final class SelectMatchViewController: ExpandingViewController{
  
  let disposeBag = DisposeBag()
  fileprivate var cellsIsOpen = [Bool](repeating: false, count: 4)
  private var datas:[MatchType] = [.relationship,.fit,.gps,.transfer]
  
  init(title: String) {
    super.init(nibName: nil, bundle: nil)
    self.title = title
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    collectionView?.emptyDataSetSource = self
    let nib = UINib(nibName: String(describing: MainViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: MainViewCell.self))

    collectionView?.alwaysBounceHorizontal = true
    navigationItem.largeTitleDisplayMode = .always
    collectionView?.contentInsetAdjustmentBehavior = .never
  }
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? MainViewCell else { return }
    cell.cellIsOpen(cellsIsOpen[indexPath.item], animated: false)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.navigationController?.pushViewController(MatchResultController(), animated: true)
  }
  
  override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return datas.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: indexPath) as! MainViewCell
    
    cell.imageView.image = datas[indexPath.item].images
    cell.titleLabel.text = datas[indexPath.item].rawValue
    return cell
  }
}



extension SelectMatchViewController: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "앗! 등록하신 여행이 없네요!!",
                              attributes: [NSAttributedStringKey.font : UIFont.NotoSansKRMedium(size: 15)])
  }
}
