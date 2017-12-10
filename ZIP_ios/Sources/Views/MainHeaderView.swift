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

final class MainHeaderView: UIView{
  
  let sampledatas:[UIImage] = [#imageLiteral(resourceName: "bmw-2964072_640"),#imageLiteral(resourceName: "kitty-2948404_640")]
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "관심사"
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.sizeToFit()
    return label
  }()
  
  let travelButton: UIButton = {
    let button = UIButton()
    button.setTitle("여행", for: .normal)
    button.layer.shadowColor = UIColor.gray.cgColor
    button.layer.shadowOffset = CGSize(width: 2, height: 2)
    button.layer.shadowOpacity = 1
    button.layer.masksToBounds = false
    button.backgroundColor = .blue
    return button
  }()
  
  let meetButton: UIButton = {
    let button = UIButton()
    button.setTitle("모임", for: .normal)
    button.backgroundColor = .blue
    return button
  }()
  
  let sampleButton: UIButton = {
    let button = UIButton()
    button.setTitle("샘플", for: .normal)
    button.backgroundColor = .blue
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
    super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
    
    addSubview(titleLabel)
    addSubview(travelButton)
    addSubview(meetButton)
    addSubview(sampleButton)
    addSubview(pageView)
    pageView.addSubview(pageControl)
    addSubview(adLabel)
    addSubview(moreButton)
    addconstraint()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addconstraint(){
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(20)
      make.top.equalToSuperview().inset(20)
    }
    
    travelButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(20)
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
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
      make.top.equalTo(travelButton.snp.bottom).offset(7.5)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(130)
    }

    pageControl.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(15)
    }

    adLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalTo(pageView.snp.bottom)
      make.height.equalTo(20)
    }

    moreButton.snp.makeConstraints { (make) in
      make.top.equalTo(adLabel.snp.bottom)
      make.left.equalToSuperview().inset(20)
    }
    moreButton.sizeToFit()
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
    adLabel.text = "\(index)"
    cell.textLabel?.text = "good"
    return cell
  }
}

