//
//  MatchSuccessViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

class MatchSuccessViewController: UIViewController{
  
  private var didUpdateConstraint = false
  
  private let bgImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "bgChattingcomplete.png")
    return imageView
  }()
  
  private let connectImage: UIImageView = {
    let image = UIImageView()
    image.image = #imageLiteral(resourceName: "bgHeartdash.png")
    return image
  }()
  
  private let myProfileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 94/2
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = .white
    return imageView
  }()
  
  private let targetProfileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 94/2
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = .white
    return imageView
  }()
  
  private let myNickName: UIButton = {
    let button = UIButton()
    button.setTitle("나", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)
    button.layer.cornerRadius = 15.8
    button.titleLabel?.font = UIFont.AppleSDGothicNeoBold(size: 13)
    return button
  }()
  
  private let targetNickName: UIButton = {
    let button = UIButton()
    button.setTitle("선미 님", for: .normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)
    button.layer.cornerRadius = 15.8
    button.titleLabel?.font = UIFont.AppleSDGothicNeoBold(size: 13)
    return button
  }()
  
  private let startChatButton: UIButton = {
    let button = UIButton()
    button.setTitle("대화 시작", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.2156862745, green: 0.3450980392, blue: 0.7843137255, alpha: 1), for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoBold(size: 18)
    button.layer.cornerRadius = 26.5
    button.backgroundColor = .white
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = bgImage
    
    self.navigationController?.navigationBar.topItem?.title = String()
    bgImage.addSubview(myProfileImage)
    bgImage.addSubview(targetProfileImage)
    bgImage.addSubview(targetNickName)
    bgImage.addSubview(myNickName)
    bgImage.addSubview(connectImage)
    bgImage.addSubview(startChatButton)
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      connectImage.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
      
      myProfileImage.snp.makeConstraints { (make) in
        make.right.equalTo(connectImage.snp.left).offset(-11)
        make.centerY.equalTo(connectImage)
        make.height.width.equalTo(94)
      }
      
      targetProfileImage.snp.makeConstraints { (make) in
        make.left.equalTo(connectImage.snp.right).offset(11)
        make.centerY.equalTo(connectImage)
        make.height.width.equalTo(94)
      }
      
      myNickName.snp.makeConstraints { (make) in
        make.top.equalTo(myProfileImage.snp.bottom).offset(14)
        make.centerX.equalTo(myProfileImage)
        make.width.equalTo(64)
        make.height.equalTo(29)
      }
      
      targetNickName.snp.makeConstraints { (make) in
        make.centerX.equalTo(targetProfileImage)
        make.top.equalTo(targetProfileImage.snp.bottom).offset(14)
        make.height.equalTo(myNickName)
      }
      
      startChatButton.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(connectImage.snp.bottom).offset(126)
        make.width.equalTo(206)
        make.height.equalTo(53)
      }
      
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
