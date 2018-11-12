//
//  MyPageSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 11/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import RxSwift
import RxCocoa
import Moya

class MyPageSectionController: ListSectionController, ListSupplementaryViewSource{
 
  let pushSubject = PublishRelay<UIViewController>()
  var item: MyPageModel?
  let disposeBag = DisposeBag()
  
  let userData =  AuthManager.instance.provider.request(.userWithProfile)
    .filterSuccessfulStatusCodes()
    .retry(3)
    .map(ResultModel<UserWithProfile>.self)
    .asObservable()
    .materialize()
    .share()
  
  override init() {
    super.init()
    userData.errors()
      .subscribe(onNext: { (err) in
        (err as? MoyaError)?.GalMalErrorHandler()
      }).disposed(by: disposeBag)
    
    supplementaryViewSource = self
    self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
  }
  func supportedElementKinds() -> [String] {
    return [UICollectionView.elementKindSectionHeader]
  }
  
  func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
    let view = collectionContext?
      .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                        for: self,
                                        class: MyPageHeaderView.self,
                                        at: index) as! MyPageHeaderView
    userData.elements()
      .subscribe(onNext: { (model) in
        view.userModel = model.result
      }).disposed(by: disposeBag)
    return view
  }
  
  func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 260)
  }
  
  override func didUpdate(to object: Any) {
    guard let item = object as? MyPageModel else {return}
    self.item = item
  }
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(of: MyPageCell.self, for: self, at: index) as! MyPageCell
    cell.titleLabel.text = item?.viewControllers[index].name
    return cell
  }
  
  override func didSelectItem(at index: Int) {
    guard let vc = item?.viewControllers[index].viewController else {return}
    pushSubject.accept(vc)
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 64)
  }
  
  override func numberOfItems() -> Int {
    return item?.viewControllers.count ?? 0
  }
}
