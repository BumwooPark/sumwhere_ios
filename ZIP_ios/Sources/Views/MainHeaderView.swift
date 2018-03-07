//
//  MainHeaderView.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 10..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import FSPagerView
import LTMorphingLabel
import RxSwift
import RxCocoa

final class MainHeaderView: UICollectionReusableView{
  
  let sampledatas:[UIImage] = [#imageLiteral(resourceName: "maxresdefault"),#imageLiteral(resourceName: "maxresdefault")]
  weak var mainViewController: MainViewController?
  private let disposeBag = DisposeBag()
  let travelButton: UIButton = {
    let button = UIButton()
    button.setTitle("여행", for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "travle").image(alpha: 0.6), for: .normal)
    button.layer.shadowColor = UIColor.gray.cgColor
    button.layer.shadowOffset = CGSize(width: 2, height: 2)
    button.layer.shadowOpacity = 1
    button.layer.masksToBounds = false
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.layer.cornerRadius = 5
    button.backgroundColor = .lightGray
    button.isUserInteractionEnabled = true
    return button
  }()
  
  let meetButton: UIButton = {
    let button = UIButton()
    button.setTitle("모임", for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "meet").image(alpha: 0.6), for: .normal)
    button.layer.shadowColor = UIColor.gray.cgColor
    button.layer.shadowOffset = CGSize(width: 2, height: 2)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.layer.shadowOpacity = 1
    button.layer.masksToBounds = false
    button.layer.cornerRadius = 5
    button.backgroundColor = .lightGray
    return button
  }()
  
  let sampleButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "cake-3019645_640").image(alpha: 0.6), for: .normal)
    button.setTitle("맛집", for: .normal)
    button.layer.shadowColor = UIColor.gray.cgColor
    button.layer.shadowOffset = CGSize(width: 2, height: 2)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.layer.shadowOpacity = 1
    button.layer.masksToBounds = false
    button.layer.cornerRadius = 5
    button.backgroundColor = .lightGray
    return button
  }()
  
  lazy var pageView: FSPagerView = {
    let pageView = FSPagerView()
    pageView.alwaysBounceHorizontal = true
    pageView.dataSource = self
    pageView.delegate = self
    pageView.automaticSlidingInterval = 4.0
    pageView.isInfinite = true
    pageView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    return pageView
  }()
  
  let pageControl: FSPageControl = {
    let pageControl = FSPageControl()
    pageControl.numberOfPages = 2
    pageControl.hidesForSinglePage = true
    pageControl.contentHorizontalAlignment = .fill
    pageControl.currentPage = 0
    return pageControl
  }()
  
  let adLabel: LTMorphingLabel = {
    let label = LTMorphingLabel()
    label.morphingEffect = .evaporate
    label.morphingEnabled = true
    label.textAlignment = .center
    label.text = "이것은 광고입니다.!!!"
    return label
  }()
  
  let moreButton: UIButton = {
    let button = UIButton()
    button.setTitle("더보기", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
  
    addSubview(travelButton)
    addSubview(meetButton)
    addSubview(sampleButton)
    addSubview(pageView)
    pageView.addSubview(pageControl)
    addconstraint()
    
    travelButton
      .rx
      .tap
      .subscribe{[weak self] _ in
        self?.mainViewController?.eventAction.onNext(.Travel)
    }.disposed(by: disposeBag)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addconstraint(){
    
    travelButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(20)
      make.top.equalTo(pageView.snp.bottom).offset(20)
      make.width.equalToSuperview().dividedBy(4)
      make.height.equalTo(travelButton.snp.width)
    }

    meetButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(travelButton)
      make.width.equalTo(travelButton)
      make.height.equalTo(travelButton)
    }

    sampleButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(20)
      make.top.equalTo(travelButton)
      make.width.equalTo(travelButton)
      make.height.equalTo(travelButton)
    }

    pageView.snp.makeConstraints { (make) in
      make.right.top.left.equalToSuperview()
      make.height.equalTo(150)
    }

    pageControl.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(15)
    }

//    adLabel.snp.makeConstraints { (make) in
//      make.left.equalToSuperview()
//      make.right.equalToSuperview()
//      make.top.equalTo(titleLabel.snp.bottom).offset(20)
//      make.height.equalTo(20)
//    }

//    moreButton.snp.makeConstraints { (make) in
//      make.top.equalTo(adLabel.snp.bottom)
//      make.left.equalToSuperview().inset(20)
//    }
//    moreButton.sizeToFit()
  }
}

extension MainHeaderView: FSPagerViewDelegate{
  
  func pagerViewDidScroll(_ pagerView: FSPagerView) {
    pageControl.currentPage = pageView.currentIndex
  }
}

extension MainHeaderView: FSPagerViewDataSource{
  public func numberOfItems(in pagerView: FSPagerView) -> Int {
    return 2
  }
  
  public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
    cell.imageView?.image = sampledatas[index]
//    adLabel.text = "\(index)"
    cell.textLabel?.text = "우리여행"
    cell.textLabel?.font = UIFont.NotoSansKRMedium(size: 13)
    return cell
  }
}

