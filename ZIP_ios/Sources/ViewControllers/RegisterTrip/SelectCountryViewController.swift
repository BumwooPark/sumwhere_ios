//
//  SelectCountryViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 09/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import PreviewTransition
import RxDataSources
import RxSwift
import RxCocoa
import Kingfisher

class SelectCountryViewController: PTTableViewController{
  
  private let disposeBag = DisposeBag()
  
  let API = AuthManager.instance.provider
    .request(.Countrys)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[Country]>.self)
    .map{$0.result}
    .asObservable()
    .retry(.exponentialDelayed(maxCount: 3, initial: 2, multiplier: 2))
    .unwrap()
    .materialize()
    .share()
  
  private let datas = BehaviorRelay<[GenericSectionModel<Country>]>(value: [])
  private let dataSources = RxTableViewSectionedReloadDataSource<GenericSectionModel<Country>>(
    configureCell: {ds,tv,idx,item in
      let cell = tv.dequeueReusableCell(withIdentifier: String(describing: ParallaxCell.self), for: idx) as! ParallaxCell
      KingfisherManager.shared.retrieveImage(with: URL(string: item.imageUrl.addSumwhereImageURL())!, completionHandler: { (result) in
        guard let image = result.value?.image else {
          cell.setImage(UIImage(), title: item.name)
          return
        }
        
        cell.setImage(image, title: item.name)
      })
      return cell
  })
  
  var didUpdateConstraint = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ParallaxCell.self, forCellReuseIdentifier: String(describing: ParallaxCell.self))
    tableView.rowHeight = 200
    tableView.dataSource = nil
    
    datas
      .asDriver()
      .drive(tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.AppleSDGothicNeoSemiBold(size: 30),.foregroundColor: UIColor.white]
    
    tableView.rx.modelSelected(Country.self)
      .subscribeNext(weak: self) { (weakSelf) -> (Country) -> Void in
        return {item in
          tripRegisterContainer.register(Country.self, factory: { _ in item})
          let vc = DetailCountryViewController(model: item)
          weakSelf.pushViewController(vc)
        }
      }.disposed(by: disposeBag)
    
    API.elements()
      .map{[GenericSectionModel<Country>(items: $0)]}
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    API.errors()
      .subscribe(weak: self) { (weakSelf) -> (Event<Error>) -> Void in
        return {error in
          log.error(error)
        }
    }.disposed(by: disposeBag)
    
  }
}


