//
//  DetailHistoryViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 21/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Kingfisher

final class DetailHistoryViewController: UIViewController {
  private var didUpdateConstraint = false
  let model: MatchHistoryModel
  let viewModel: DetailHistoryTypes = DetailHistoryViewModel()
  private let contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = model.trip.region
    label.font = UIFont.AppleSDGothicNeoBold(size: 17.8)
    return label
  }()
  
  lazy var tripTimeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "calendaricon.png"), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    button.titleLabel?.font = .AppleSDGothicNeoRegular(size: 14)
    button.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1), for: .normal)
    button.setTitle("\(model.trip.startDate.dateTimetoFormat(format: "yyyy-MM-dd") ?? String()) - \(model.trip.endDate.dateTimetoFormat(format: "yyyy-MM-dd") ?? String())", for: .normal)
    button.isEnabled = false
    return button
  }()
  
  private let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    return view
  }()
  
  private let gradientView: UIView = UIView()
  private let emptyView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.masksToBounds = true
    return view
  }()
  
  lazy var profileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.kf.setImage(with: URL(string: model.profile.image1.addSumwhereImageURL()), options: [.transition(.fade(0.2))])
    return imageView
  }()
  
  private let nickNameLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let explainLabel: UILabel = {
    let label = UILabel()
    label.layer.cornerRadius = 6
    label.layer.masksToBounds = true
    label.textAlignment = .center
    label.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    return label
  }()
  
  init(matchHistoryModel: MatchHistoryModel) {
    model = matchHistoryModel
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    view.addSubview(contentView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(tripTimeButton)
    contentView.addSubview(dividLine)
    contentView.addSubview(gradientView)
    gradientView.addSubview(emptyView)
    contentView.addSubview(nickNameLabel)
    emptyView.addSubview(profileImage)
    contentView.addSubview(nickNameLabel)
    contentView.addSubview(explainLabel)
    
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    contentView.layer.cornerRadius = 19.4
    gradientView.layer.cornerRadius = gradientView.frame.width/2
    gradientView.clipsToBounds = true
    gradientView.gradientBackground(from: #colorLiteral(red: 0.4352941176, green: 0.4117647059, blue: 1, alpha: 1), to: #colorLiteral(red: 0.1803921569, green: 0.5647058824, blue: 0.8823529412, alpha: 1), direction: GradientDirection.bottomToTop)
    emptyView.layer.cornerRadius = emptyView.frame.width/2
    profileImage.layer.cornerRadius = profileImage.frame.width/2
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint {
      
      contentView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 100, left: 34, bottom: 100, right: 34))
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(33)
        make.centerX.equalToSuperview()
      }
      
      tripTimeButton.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(4.2)
        make.centerX.equalToSuperview()
      }
      
      dividLine.snp.makeConstraints { (make) in
        make.top.equalTo(tripTimeButton.snp.bottom).offset(22.8)
        make.left.right.equalToSuperview().inset(26)
        make.height.equalTo(2)
      }
      
      gradientView.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalTo(dividLine.snp.bottom).offset(18)
        make.height.width.equalTo(132)
      }
      
      emptyView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
      }
      
      profileImage.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
      }
      
      nickNameLabel.snp.makeConstraints { (make) in
        make.top.equalTo(gradientView.snp.bottom).offset(13.2)
        make.centerX.equalToSuperview()
      }
      
      explainLabel.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview().inset(11)
        make.height.equalTo(71)
      }
      
      didUpdateConstraint = true
    }
    
    super.updateViewConstraints()
  }
}
