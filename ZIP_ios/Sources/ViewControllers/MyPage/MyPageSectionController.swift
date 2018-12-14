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
 
  let settingSubject = PublishRelay<SettingType>()
  var item: MyPageModel?
  let disposeBag = DisposeBag()
  
  let userData =  AuthManager.instance.provider
    .request(.userWithProfile)
    .filterSuccessfulStatusCodes()
    .retry(3)
    .map(ResultModel<UserWithProfile>.self)
    .asObservable()
    .materialize()
    
  
  override init() {
    super.init()
    userData.errors()
      .map{($0 as? MoyaError)}
      .bindGalMalError()
      .disposed(by: disposeBag)
    
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
    
    view.storeButton.rx.tap
      .map{SettingType.ViewController(viewController: PurchaseViewController())}
      .bind(to: settingSubject)
      .disposed(by: disposeBag)
    view.userModel = globalUserInfo
    
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
    guard let type = item?.viewControllers[index].type else {return}
    settingSubject.accept(type)
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 64)
  }
  
  override func numberOfItems() -> Int {
    return item?.viewControllers.count ?? 0
  }
}
