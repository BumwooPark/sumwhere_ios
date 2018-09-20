//
//  ProfileImageViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift

final class ProfileImageViewController: UIViewController, ProfileCompletor{
  private let disposeBag = DisposeBag()
  
  var completeSubject: PublishSubject<Void>?
  var didUpdateConstraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "당신의 모습이 잘 담긴\n사진을 등록해주세요"
    label.font = .AppleSDGothicNeoMedium(size: 20)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    label.numberOfLines = 2
    return label
  }()
  
  private let tipButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 12
    button.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.4549019608, blue: 0.8078431373, alpha: 1).cgColor
    button.layer.borderWidth = 1
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 12)
    button.setTitle("TIP", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.2705882353, green: 0.4549019608, blue: 0.8078431373, alpha: 1), for: .normal)
    return button
  }()
  
  private let detailLabel: UILabel = {
    let attributeString = NSMutableAttributedString(string: "상대방이 주목할 만한 사진을 업로드 해주세요\n",
                                                    attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 14),
                                                                 .foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)])
    attributeString.append(NSAttributedString(string: "- 여행 풍경만 담긴 사진은 추천하지 않아요\n- 최소 2장의 사진을 업로드 해주세요",
                                              attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 14),
                                                           .foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)]))
    
    let label = UILabel()
    label.attributedText = attributeString
    label.numberOfLines = 3
    return label
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 137, height: 137)
    layout.minimumLineSpacing = 16
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: String(describing: ProfileImageCell.self))
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 21)
    button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    button.isEnabled = false
    return button
  }()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {[weak self] in
      self?.completeSubject?.onNext(())
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(titleLabel)
    view.addSubview(collectionView)
    view.addSubview(tipButton)
    view.addSubview(detailLabel)
    view.addSubview(nextButton)
    
    Observable.just([Int](0...3))
      .bind(to: collectionView.rx.items(cellIdentifier: String(describing: ProfileImageCell.self), cellType: ProfileImageCell.self)){ idx, item, cell in
        return cell
    }.disposed(by: disposeBag)
    
    
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview().inset(-200)
        make.left.equalToSuperview().inset(41)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.height.width.equalTo(290)
        make.center.equalToSuperview()
      }
      
      tipButton.snp.makeConstraints { (make) in
        make.top.equalTo(collectionView.snp.bottom).offset(10)
        make.left.equalTo(collectionView)
        make.width.equalTo(39)
        make.height.equalTo(24)
      }
      
      detailLabel.snp.makeConstraints { (make) in
        make.left.equalTo(tipButton.snp.right).offset(8)
        make.top.equalTo(tipButton)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(61)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

class ProfileImageCell: UICollectionViewCell{
  
  let profileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "fill1.png")
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
