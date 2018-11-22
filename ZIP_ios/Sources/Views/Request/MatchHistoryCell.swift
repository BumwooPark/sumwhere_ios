//
//  ReceiveCell.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

final class MatchHistoryCell: UICollectionViewCell{
  
  private let disposeBag = DisposeBag()
  private var didUpdateConstraint = false
  
  private let circleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 7.5
    view.layer.borderWidth = 1.7
    view.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.7764705882, blue: 0.4509803922, alpha: 1)
    return view
  }()
  
  private let line: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
    return view
  }()
  
  let matchTitleLabel: UILabel = {
    let attributedString = NSMutableAttributedString(string: "즉흥 매칭", attributes: [
      .font: UIFont(name: "AppleSDGothicNeo-Medium", size: 19.0)!,
      .foregroundColor: UIColor(white: 11.0 / 255.0, alpha: 1.0),
      .kern: -0.8
      ])
    attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 19.0)!, range: NSRange(location: 3, length: 1))
    let label = UILabel()
    label.attributedText = attributedString
    return label
  }()
  
  let matchDateLabel: UILabel = {
    let attributedString = NSMutableAttributedString(string: "오늘, 9월 19일 2019", attributes: [
      .font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 11.0)!,
      .foregroundColor: UIColor(white: 97.0 / 255.0, alpha: 1.0),
      .kern: 0.2
      ])
    attributedString.addAttributes([
      .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 11.0)!,
      .foregroundColor: UIColor(white: 66.0 / 255.0, alpha: 1.0)
      ], range: NSRange(location: 0, length: 2))
    attributedString.addAttributes([
      .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 11.0)!,
      .foregroundColor: UIColor(white: 11.0 / 255.0, alpha: 1.0)
      ], range: NSRange(location: 2, length: 1))
    let label = UILabel()
    label.attributedText = attributedString
    return label
  }()
  
  let collectionView: UICollectionView = {
    let layout = PageCollectionLayout(itemSize: CGSize(width: 77, height: 180))
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(RequestProfileCell.self, forCellWithReuseIdentifier: String(describing: RequestProfileCell.self))
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.alwaysBounceHorizontal = true 
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(circleView)
    contentView.addSubview(line)
    contentView.addSubview(matchTitleLabel)
    contentView.addSubview(matchDateLabel)
    contentView.addSubview(collectionView)
    Observable.just([1,2,3,4,5,6,7,8,9]).bind(to: collectionView.rx.items(cellIdentifier: String(describing: RequestProfileCell.self), cellType: RequestProfileCell.self)){ index, model, cell in
      
      }.disposed(by: disposeBag)
    
    
    collectionView.rx
      .itemSelected
      .subscribeNext(weak: self) { (weakSelf) -> (IndexPath) -> Void in
        return {idx in
          AppDelegate.instance?.window?.rootViewController?.present(ProfileViewController(), animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    
    
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraint{
      
      circleView.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(32)
        make.top.equalToSuperview().inset(40)
        make.height.width.equalTo(15)
      }
      
      line.snp.makeConstraints { (make) in
        make.top.equalTo(circleView.snp.bottom)
        make.width.equalTo(2)
        make.height.equalTo(63)
        make.centerX.equalTo(circleView)
      }
      
      matchTitleLabel.snp.makeConstraints { (make) in
        make.left.equalTo(circleView.snp.right).offset(12.6)
        make.centerY.equalTo(circleView)
      }
      
      matchDateLabel.snp.makeConstraints { (make) in
        make.left.equalTo(matchTitleLabel)
        make.top.equalTo(matchTitleLabel.snp.bottom).offset(7)
      }
  
      collectionView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview()
        make.top.equalTo(line.snp.bottom)
      }
      
      didUpdateConstraint = true
    }
    super.updateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
