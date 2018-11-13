//
//  VersionViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 13/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController{
  
  private var didUpdateConstraint = false
  private let scrollView: UIScrollView = {
    let view = UIScrollView()
    view.backgroundColor = .white
    view.alwaysBounceVertical = true
    return view
  }()
  
  private let contentView: UIView = UIView()
  
  //  fileprivate let logoimg:UIImageView = {
  //    let img = UIImageView(image: #imageLiteral(resourceName: "logo"))
  //    return img
  //  }()
  
  fileprivate lazy var appNameLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoMedium(size: 18)
    label.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    return label
  }()
  
  fileprivate let appVersionLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    label.font = .AppleSDGothicNeoMedium(size: 14)
    label.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    return label
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "버전정보"
    
    view = scrollView
    scrollView.addSubview(contentView)
    contentView.addSubview(appNameLabel)
    contentView.addSubview(appVersionLabel)
    view.updateConstraintsIfNeeded()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      contentView.snp.makeConstraints { (make) in
        make.right.left.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(self.view).priority(.low)
      }
      
      appNameLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(10)
        make.top.equalToSuperview().inset(10)
      }
      
      appVersionLabel.snp.makeConstraints { (make) in
        make.left.equalTo(appNameLabel.snp.right).offset(10)
        make.centerY.equalTo(appNameLabel)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
