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
import Pastel

class DetailCategoryViewController: UIViewController{
  
  let imageView: PastelView = {
    let image = PastelView(frame: UIScreen.main.bounds)
    image.startPastelPoint = .bottomLeft
    image.endPastelPoint = .topRight
    image.animationDuration = 3.0
    image.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                     UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                     UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                     UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                     UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                     UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                     UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
    image.heroID = "backImageView"
    image.startAnimation()
    return image
  }()
  
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
    collectionView.backgroundView = imageView
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
