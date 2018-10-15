//
//  MatchSelectSectionController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 12/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import UIKit

final class MatchSelectSectionController: ListSectionController{
  
  var item: DataSectionItem?
  
  override func sizeForItem(at index: Int) -> CGSize {
    if item?.isSelected ?? false {
      return CGSize(width: collectionContext!.containerSize.width, height: 337)
    }else {
      return CGSize(width: collectionContext!.containerSize.width, height: 144)
    }
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(of: MatchSelectCell.self, for: self, at: index) as! MatchSelectCell
    cell.item = item
    return cell
  }
  
  override func didUpdate(to object: Any) {
    
    guard let item = object as? DataSectionItem else {return}
    self.item = item
  }
  
  override func numberOfItems() -> Int {
    return 1 // One hero will be represented by one cell
  }
//  337
  
  override func didDeselectItem(at index: Int) {
    self.item?.isSelected = false
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.4,
                   initialSpringVelocity: 0.6,
                   options: [],
                   animations: {
                    self.collectionContext?.invalidateLayout(for: self)
    })
  }
  
  override func didSelectItem(at index: Int) {
    self.item?.isSelected = true
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.4,
                   initialSpringVelocity: 0.6,
                   options: [],
                   animations: {
                    self.collectionContext?.invalidateLayout(for: self)
    })
  }
}


final class MatchSelectCell: UICollectionViewCell{
  
  var didUpdateContraint = false
  
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
    label.font = .AppleSDGothicNeoBold(size: 23)
    label.textColor = .white
    return label
  }()
  
  private let startMatchButton: UIButton = {
    let button = UIButton()
    button.setTitle("매칭하러 가기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 20.8
    button.layer.borderWidth = 0.8
    button.layer.borderColor = UIColor.white.cgColor
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(backImageView)
    backImageView.addSubview(titleLabel)
    backImageView.addSubview(startMatchButton)
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
        make.height.equalTo(30)
        make.width.equalTo(110)
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
