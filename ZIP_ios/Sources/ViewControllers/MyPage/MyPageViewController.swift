//
//  MyPageViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController, ListAdapterDataSource {
  let disposeBag = DisposeBag()

  var items: [ListDiffable] = [
    MyPageModel(header: "default",viewControllers: [
      PageCellDataModel(name: "알림 설정", viewController: AlertSettingViewController()),
      PageCellDataModel(name: "계정 설정", viewController: UIViewController())]),
    SupportModel(header: "고객 지원", viewControllers: [
      PageCellDataModel(name: "공지사항", viewController: UIViewController()),
      PageCellDataModel(name: "문의하기", viewController: UIViewController()),
      PageCellDataModel(name: "접근권한", viewController: UIViewController()),
      PageCellDataModel(name: "문의하기", viewController: UIViewController()),
      PageCellDataModel(name: "공지 & 이벤트", viewController: UIViewController()),
      PageCellDataModel(name: "오픈라이센스", viewController: UIViewController()),
      PageCellDataModel(name: "버전정보", viewController: UIViewController())])]
  
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    collectionView.register(MyPageHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: MyPageHeaderView.self))
    collectionView.register(SupportHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: String(describing: SupportHeaderView.self))
    collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: String(describing: MyPageCell.self))
    collectionView.register(SupportCell.self, forCellWithReuseIdentifier: String(describing: SupportCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return items
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    
    switch object{
    case is MyPageModel:
      return Init(MyPageSectionController()) { (vc) in
        vc.pushSubject.subscribeNext(weak: self, { (weakSelf) -> (UIViewController) -> Void in
          return {vc in
            weakSelf.navigationController?.pushViewController(vc, animated: true)
          }
        }).disposed(by: disposeBag)
      }
    case is SupportModel:
      return Init(OtherMyPageSectionController()) { (vc) in
        vc.pushSubject.subscribeNext(weak: self, { (weakSelf) -> (UIViewController) -> Void in
          return {vc in
            weakSelf.navigationController?.pushViewController(vc, animated: true)
          }
        }).disposed(by: disposeBag)
      }
    default:
      return MyPageSectionController()
    }
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = String()
    view = collectionView
    _ = adapter
  }
}
