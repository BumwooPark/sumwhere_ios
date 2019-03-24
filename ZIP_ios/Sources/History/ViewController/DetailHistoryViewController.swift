//
//  DetailHistoryViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 21/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Kingfisher
import RxSwift
import RxCocoa
import Moya

final class DetailHistoryViewController: UIViewController {
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  let model: MatchHistoryModel  
  let isReceive: Bool
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
  
  lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    let attributedString = NSMutableAttributedString(string: model.user.nickname ?? String(), attributes: [.font:UIFont.AppleSDGothicNeoBold(size: 22),.foregroundColor: #colorLiteral(red: 0.01176470588, green: 0.01176470588, blue: 0.01176470588, alpha: 1)])
    attributedString.append(NSAttributedString(string: " \(model.profile.age)살", attributes: [.font: UIFont.AppleSDGothicNeoLight(size: 15),.foregroundColor: UIColor.black]))
    label.attributedText = attributedString
    return label
  }()
  
  lazy var textView: UITextView = {
    let textView = UITextView()
    textView.layer.cornerRadius = 6
    textView.layer.masksToBounds = true
    textView.isEditable = false
    textView.text = model.trip.activity
    textView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    return textView
  }()
  
  private let acceptButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonAccept.png"), for: .normal)
    return button
  }()
  
  let acceptLabel: UILabel = {
    let label = UILabel()
    label.text = "수락"
    label.font = .AppleSDGothicNeoBold(size: 12.6)
    label.textColor = #colorLiteral(red: 0.01568627451, green: 0.568627451, blue: 1, alpha: 1)
    return label
  }()
  
  private let refuseButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "buttonRefuse.png"), for: .normal)
    return button
  }()
  
  private let refuseLabel: UILabel = {
    let label = UILabel()
    label.text = "거절"
    label.font = .AppleSDGothicNeoBold(size: 12.6)
    label.textColor = #colorLiteral(red: 0.01568627451, green: 0.568627451, blue: 1, alpha: 1)
    return label
  }()
  
  init(matchHistoryModel: MatchHistoryModel, isReceive: Bool) {
    model = matchHistoryModel
    self.isReceive = isReceive
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "받은 요청"
    self.navigationController?.navigationBar.topItem?.title = String()
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
    contentView.addSubview(textView)
    if isReceive{
      receive()
    }
    view.setNeedsUpdateConstraints()
  }
  
  private func receive(){
    guard model.matchHistory.state == "NONE" else {return}
    view.addSubview(acceptLabel)
    view.addSubview(acceptButton)
    view.addSubview(refuseLabel)
    view.addSubview(refuseButton)
    
    refuseButton.snp.makeConstraints { (make) in
      make.right.equalTo(self.view.snp.centerX).inset(-40)
      make.top.equalTo(contentView.snp.bottom).offset(30)
    }
    
    refuseLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(refuseButton)
      make.top.equalTo(refuseButton.snp.bottom).offset(8)
    }
    
    acceptButton.snp.makeConstraints { (make) in
      make.left.equalTo(self.view.snp.centerX).inset(40)
      make.top.equalTo(refuseButton)
    }
    
    acceptLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(acceptButton)
      make.top.equalTo(acceptButton.snp.bottom).offset(8)
    }
    
    acceptButton.rx.tap
      .map{self.model.matchHistory.id}
      .bind(onNext: viewModel.inputs.accept)
      .disposed(by: disposeBag)
    
    refuseButton.rx.tap
      .map{self.model.matchHistory.id}
      .bind(onNext: viewModel.inputs.refuse)
      .disposed(by: disposeBag)
    
    viewModel.outputs.acceptResult
      .elements()
      .subscribeNext(weak: self) { (weakSelf) -> (Response) -> Void in
        return {_ in
          log.info("success")
        }
      }.disposed(by: disposeBag)
    
    viewModel.outputs.acceptResult
      .errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return { err in
          log.error(err)
        }
      }.disposed(by: disposeBag)
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
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 100, left: 34, bottom: 200, right: 34))
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
      
      textView.snp.makeConstraints { (make) in
        make.left.right.bottom.equalToSuperview().inset(11)
        make.top.equalTo(nickNameLabel.snp.bottom).offset(13).priority(.low)
      }
      
      
      
//      if isReceive{
//        guard model.matchHistory.state == "NONE" else {return}
//        refuseButton.snp.makeConstraints { (make) in
//          make.right.equalTo(self.view.snp.centerX).inset(-40)
//          make.top.equalTo(contentView.snp.bottom).offset(30)
//        }
//
//        refuseLabel.snp.makeConstraints { (make) in
//          make.centerX.equalTo(refuseButton)
//          make.top.equalTo(refuseButton.snp.bottom).offset(8)
//        }
//
//        acceptButton.snp.makeConstraints { (make) in
//          make.left.equalTo(self.view.snp.centerX).inset(40)
//          make.top.equalTo(refuseButton)
//        }
//
//        acceptLabel.snp.makeConstraints { (make) in
//          make.centerX.equalTo(acceptButton)
//          make.top.equalTo(acceptButton.snp.bottom).offset(8)
//        }
//      }
//
      
      didUpdateConstraint = true
    }
    
    super.updateViewConstraints()
  }
}
