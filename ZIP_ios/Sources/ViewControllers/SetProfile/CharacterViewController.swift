//
//  CharacterViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Eureka
import RxCocoa
import RxSwift
import RxDataSources
import DZNEmptyDataSet

class CharacterViewController: UIViewController, TypedRowControllerType{
  var row: RowOf<String>!
  var onDismissCallback: ((UIViewController) -> Void)?
  
  var selectedModel: [CharacterModel] = []
  let datas = BehaviorRelay<[CharacterViewModel]>(value: [])
  let disposeBag = DisposeBag()
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<CharacterViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCell.self), for: idx) as! CharacterCell
    cell.titleLabel.text = item.typeName
    return cell
  },configureSupplementaryView:{ds,cv, kind, idx in
    
    switch kind{
    case UICollectionElementKindSectionHeader:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: CharacterHeaderView.self), for: idx) as! CharacterHeaderView
      return view
    case UICollectionElementKindSectionFooter:
      let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: CharacterFooterView.self), for: idx) as! CharacterFooterView
      return view
    default:
      log.info("kind default")
    }
    return UICollectionReusableView()
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 10
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
    layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 , height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: String(describing: CharacterCell.self))
    collectionView.register(CharacterHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: CharacterHeaderView.self))
    collectionView.register(CharacterFooterView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                            withReuseIdentifier: String(describing: CharacterFooterView.self))
    collectionView.emptyDataSetSource = self
    collectionView.allowsMultipleSelection = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    navigationItem.largeTitleDisplayMode = .never
    
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    let selected = collectionView.rx.itemSelected
    let deselected = collectionView.rx.itemDeselected
    
    Observable.of(selected,deselected).merge()
      .map{_ in return ()}
      .bind(onNext: collectionViewFooterButtonSetting)
      .disposed(by: disposeBag)
    
    api()
  }
  
  //MARK: - Network Call
  private func api(){
    AuthManager.provider.request(.GetAllCharacter)
      .map(ResultModel<[CharacterModel]>.self)
      .map{$0.result}
      .asObservable()
      .catchErrorJustReturn([])
      .filterNil()
      .map{[CharacterViewModel(items: $0)]}
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  
  func collectionViewFooterButtonSetting(){
    guard let view = collectionView
      .supplementaryView(forElementKind: UICollectionElementKindSectionFooter,
                         at: IndexPath(row: 0, section: 0)) as? CharacterFooterView else {return}
    
    if collectionView.indexPathsForSelectedItems?.count == 0{
      log.info("false")
      view.commitButton.isEnabled = false
      view.commitButton.bgColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }else{
      log.info("true")
      view.commitButton.isEnabled = true
      view.commitButton.bgColor = #colorLiteral(red: 0.04194890708, green: 0.5622439384, blue: 0.8219085336, alpha: 1)
    }
  }
}

extension CharacterViewController: DZNEmptyDataSetSource{
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    return Init(UIActivityIndicatorView(activityIndicatorStyle: .gray)){
      $0.startAnimating()
    }
  }
}
