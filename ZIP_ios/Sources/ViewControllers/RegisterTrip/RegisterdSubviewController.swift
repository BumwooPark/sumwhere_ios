//
//  RegisterdSubviewController.swift
//  ZIP_ios
//
//  Created by xiilab on 29/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//


import RxDataSources
import RxCocoa
import RxSwift

class RegisterdSubviewController: UIViewController, UICollectionViewDelegateFlowLayout{
  private let disposeBag = DisposeBag()
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GenericSectionModel<Sample>>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(
      withReuseIdentifier: String(describing: ResisterdSubviewCell.self), for: idx) as! ResisterdSubviewCell
    return cell
  })
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ResisterdSubviewCell.self, forCellWithReuseIdentifier: String(describing: ResisterdSubviewCell.self))
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceHorizontal = true
    return collectionView
  }()
  
  override func loadView() {
    super.loadView()
    view = collectionView
    
    Observable
      .just([GenericSectionModel<Sample>(items: [Sample(id: 1),Sample(id: 2),Sample(id: 3)])])
      .bind(to: collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: 100, height: 30)
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)

  }
}

class ResisterdSubviewCell: UICollectionViewCell{
  
  private let cellButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    button.layer.masksToBounds = true
    button.setImage(#imageLiteral(resourceName: "currentTimeIcon.png"), for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(cellButton)
    cellButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    cellButton.layer.cornerRadius = contentView.frame.height/2
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


struct Sample{
  let id: Int
}
