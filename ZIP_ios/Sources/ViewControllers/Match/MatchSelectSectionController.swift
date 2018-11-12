//
//  MatchSelectSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 12/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import RxSwift
import RxCocoa
import UIKit

final class MatchSelectSectionController: ListSectionController{
  
  var item: DataSectionItem?
  let disposeBag = DisposeBag()
  
  override func sizeForItem(at index: Int) -> CGSize {
    if item?.isSelected ?? false {
      return CGSize(width: collectionContext!.containerSize.width - 40, height: 337)
    }else {
      return CGSize(width: collectionContext!.containerSize.width - 40 , height: 144)
    }
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(of: MatchSelectCell.self, for: self, at: index) as! MatchSelectCell
    cell.item = item
    
    
    cell.startMatchButton.isUserInteractionEnabled = true
    cell.startMatchButton.rx.tap
      .subscribe { (evemt) in
        log.info(evemt)
      }.disposed(by: disposeBag)
    return cell
  }
  
  override func didUpdate(to object: Any) {
    
    guard let item = object as? DataSectionItem else {return}
    self.item = item
  }
  
  override func numberOfItems() -> Int {
    return 1 // One hero will be represented by one cell
  }

  override init() {
    super.init()
    self.inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
  }
  
  override func didDeselectItem(at index: Int) {
//    self.item?.isSelected = false
//    UIView.animate(withDuration: 0.5,
//                   delay: 0,
//                   usingSpringWithDamping: 0.5,
//                   initialSpringVelocity: 0.6,
//                   options: [],
//                   animations: {
//                    self.collectionContext?.invalidateLayout(for: self)
//    })
  }
  
  override func didSelectItem(at index: Int) {
//    self.item?.isSelected = true
//    UIView.animate(withDuration: 0.5,
//                   delay: 0,
//                   usingSpringWithDamping: 0.5,
//                   initialSpringVelocity: 0.6,
//                   options: [],
//                   animations: {
//                    self.collectionContext?.invalidateLayout(for: self)
//    })
  }
}


final class MatchSelectCell: UICollectionViewCell{
  
  var didUpdateContraint = false
  let disposeBag = DisposeBag()
  override var isSelected: Bool{
    didSet{
      selectedLayout(isSelectedCell: isSelected)
    }
  }
  
  var item: DataSectionItem?{
    didSet{
      backImageView.image = item?.image
      titleLabel.text = item?.name
    }
  }
  
  private let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoBold(size: 25)
    label.textColor = .white
    return label
  }()
  
  let startMatchButton: UIButton = {
    let button = UIButton()
    button.setTitle("매칭하러 가기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 20)
    button.layer.cornerRadius = 10
    button.layer.borderWidth = 0.8
    button.layer.borderColor = UIColor.white.cgColor
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = 10
    contentView.addSubview(backImageView)
    backImageView.addSubview(titleLabel)
    backImageView.addSubview(startMatchButton)
    
    contentView.rx.tapGesture()
      .subscribeNext(weak: self) { (weakSelf) -> (UITapGestureRecognizer) -> Void in
        return {_ in
          weakSelf.item?.isSelected = (weakSelf.item?.isSelected ?? true) ? false : true
        }
      }.disposed(by: disposeBag)
    
    setNeedsUpdateConstraints()
  }
  
  func selectedLayout(isSelectedCell: Bool){
    startMatchButton.isHidden = !isSelectedCell
    if isSelectedCell{
      titleLabel.snp.remakeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().inset(-100)
      }
      
      startMatchButton.snp.remakeConstraints { (make) in
        make.height.equalTo(40)
        make.width.equalTo(150)
        make.centerX.equalToSuperview()
        make.bottom.equalToSuperview().inset(70)
      }
    }else{
      titleLabel.snp.remakeConstraints { (make) in
        make.center.equalToSuperview()
      }
    }
    
    self.setNeedsLayout()
  }
  
  override func setNeedsUpdateConstraints(){
    if !didUpdateContraint {
      backImageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
      didUpdateContraint = true
    }
    super.setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
