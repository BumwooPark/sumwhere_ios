//
//  DetailCategoryViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 3. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//



//TODO: 해야될 일
/*
 InsertViewController 로부터 날짜 받은후에 국가 선택후 Detail 페이지 진입
 */


import UIKit

import RxSwift
import RxCocoa
import RxDataSources

class DetailCategoryViewController: UIViewController{
  
  let api = AuthManager.provider
  let disposeBag = DisposeBag()
  let datas = Variable<[CountryViewModel]>([])
  let dataSources = RxCollectionViewSectionedReloadDataSource<CountryViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: CountryCell.self), for: idx) as! CountryCell
    cell.model = item
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(CountryCell.self, forCellWithReuseIdentifier: String(describing: CountryCell.self))
    return collectionView
  }()
  
  override func loadView(){
    super.loadView()
    view.backgroundColor = .white
    view = collectionView
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    api.request(.country)
      .map(CountryModel.self)
      .map{[CountryViewModel(items: $0.result)]}
      .asObservable()
      .catchError({ (error) in
        log.error(error)
        return Observable<[CountryViewModel]>.of([])
      })
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
}
