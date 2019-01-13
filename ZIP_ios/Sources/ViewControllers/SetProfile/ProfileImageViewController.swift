//
//  ProfileImageViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa
import RxDataSources
import TLPhotoPicker

final class ProfileImageViewController: UIViewController, ProfileCompletor{
  
  
  var profileImage = [UIImage?](repeating: nil, count: 4){
    didSet{
      viewModel?
        .saver
        .accept(.image(value: profileImage))
      var totalCount = 0
      for img in profileImage{
        if img != nil {
          totalCount += 1
        }
      }
      
      nextButton.isEnabled = (totalCount >= 2)
      nextButton.backgroundColor = (totalCount >= 2) ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    }
  }
  weak var backSubject: PublishSubject<Void>?
  weak var completeSubject: PublishSubject<Void>?
  weak var viewModel: ProfileViewModel?
  
  
  private let imageSelected = PublishSubject<Int>()
  private let imageDeleted = PublishSubject<Int>()
  
  private var currentIndex = 0
  private let datas = BehaviorRelay<[SectionOfCustomData]>(value: [])
  
  private lazy var dataSources = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: {[unowned self] ds,cv,idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileImageCell.self), for: idx) as! ProfileImageCell
    cell.tag = idx.item
    cell.item = item
    cell.imageSelectSubject = self.imageSelected
    cell.imageDeletedSubject = self.imageDeleted
    return cell
  })
  
  private let disposeBag = DisposeBag()
  
  var didUpdateConstraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "당신의 모습이 잘 담긴\n사진을 등록해주세요"
    label.font = .KoreanSWGI1R(size: 20)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    label.numberOfLines = 2
    return label
  }()
  
  private let goodImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "exampleGood.png")
    return imageView
  }()
  
  private let goodLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoBold(size: 15)
    label.textColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    label.text = "좋은 예시"
    return label
  }()
  
  private let badImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "exampleBad.png")
    return imageView
  }()
  
  private let badLabel: UILabel = {
    let label = UILabel()
    label.text = "잘못된 예시"
    label.font = .AppleSDGothicNeoBold(size: 15)
    label.textColor = #colorLiteral(red: 0.6784313725, green: 0, blue: 0.1490196078, alpha: 1)
    return label
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png"), for: .normal)
    return button
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
    layout.itemSize = CGSize(width: 71, height: 100)
    layout.minimumInteritemSpacing = 5
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
    button.layer.cornerRadius = 10
    button.isEnabled = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(titleLabel)
    view.addSubview(backButton)
    view.addSubview(goodLabel)
    view.addSubview(goodImageView)
    view.addSubview(badLabel)
    view.addSubview(badImageView)
    view.addSubview(collectionView)
    view.addSubview(tipButton)
    view.addSubview(detailLabel)
    view.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
    reload()
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    imageSelected
      .bind(onNext: pushImageSelectView)
      .disposed(by: disposeBag)
    
    imageDeleted
      .bind(onNext: imageDelete)
      .disposed(by: disposeBag)
    
    guard let subject = completeSubject ,let back = backSubject else {return}
    
    nextButton.rx
      .tap
      .debounce(0.2, scheduler: MainScheduler.instance)
      .bind(to: subject)
      .disposed(by: disposeBag)
    
    backButton.rx
      .tap
      .bind(to: back)
      .disposed(by: disposeBag)
  }
  
  func reload(){
    imageSort()
    Observable.just([SectionOfCustomData(items: profileImage)])
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  private func pushImageSelectView(index: Int){
    let controller = TLPhotosPickerViewController(withTLPHAssets: {[weak self] (assets) in
      guard let `self` = self else {return}
      //        let resizedImage = assets.first?.fullResolutionImage?.resizeImageUsingVImage(size: CGSize(width: 500, height: 500))
      self.profileImage[index] = assets.first?.fullResolutionImage
      }, didCancel: nil)
    var configure = TLPhotosPickerConfigure()
    configure.allowedLivePhotos = true
    configure.autoPlay = true
    configure.maxSelectedAssets = 1
    controller.configure = configure
    controller.dismissCompletion = { [weak self] in
      self?.reload()
    }
    self.present(controller, animated: true, completion: nil)
  }
  
  private func imageDelete(index: Int){
    self.profileImage[index] = nil
    reload()
  }
  
  private func imageSort(){
    profileImage.sort { (one, two) -> Bool in
      if one != nil {
        if two == nil {
          return true
        }else{
          return false
        }
      }else{
        if two != nil {
          return false
        }else{
          return true
        }
      }
    }
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(69)
        make.left.equalToSuperview().inset(41)
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(10)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        make.width.height.equalTo(50)
      }
      
      goodImageView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(38)
        make.right.equalTo(self.view.snp.centerX).inset(-30)
      }
      
      badImageView.snp.makeConstraints { (make) in
        make.top.equalTo(goodImageView)
        make.left.equalTo(self.view.snp.centerX).inset(30)
      }
      
      goodLabel.snp.makeConstraints { (make) in
        make.centerX.equalTo(goodImageView)
        make.top.equalTo(goodImageView.snp.bottom).offset(10)
      }
      
      badLabel.snp.makeConstraints { (make) in
        make.centerX.equalTo(badImageView)
        make.top.equalTo(badImageView.snp.bottom).offset(10)
      }
      
      tipButton.snp.makeConstraints { (make) in
        make.top.equalTo(goodLabel.snp.bottom).offset(22)
        make.left.equalTo(goodImageView)
        make.width.equalTo(39)
        make.height.equalTo(24)
      }
      
      detailLabel.snp.makeConstraints { (make) in
        make.left.equalTo(tipButton.snp.right).offset(8)
        make.top.equalTo(tipButton)
      }
      
      
      collectionView.snp.makeConstraints { (make) in
        make.right.left.equalToSuperview().inset(34)
        make.top.equalTo(detailLabel.snp.bottom).offset(50)
        make.height.equalTo(100)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(11)
        make.height.equalTo(56)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

final class ProfileImageCell: UICollectionViewCell{
  
  private var disposeBag = DisposeBag()
  var imageSelectSubject: PublishSubject<Int>?{
    didSet{
      profileImage.rx.tap
        .map{[unowned self] _ in return self.tag}
        .bind(to: imageSelectSubject!)
        .disposed(by: disposeBag)
    }
  }
  
  var imageDeletedSubject: PublishSubject<Int>?{
    didSet{
    }
  }
  
  var item: UIImage?{
    didSet{
      if item == nil {
        profileImage.setImage(getDefaultImage(index: tag).image, for: .normal)
        commentLabel.text = getDefaultImage(index: tag).text
      }else{
        profileImage.setImage(item, for: .normal)
        commentLabel.text = getDefaultImage(index: tag).text
      }
    }
  }
  
  private let profileImage: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "photoSelect.png"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFill
    button.layer.cornerRadius = 71/2
    button.layer.masksToBounds = true
    return button
  }()
  
  private let commentLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoBold(size: 10)
    return label
  }()
  
  private func getDefaultImage(index: Int) -> (image: UIImage,text: String) {
    switch index{
    case 0:
      return (#imageLiteral(resourceName: "photoMust1.png") , "대표사진")
    case 1:
      return (#imageLiteral(resourceName: "photoMust2.png") , "필수항목")
    default:
      return (#imageLiteral(resourceName: "photoSelect.png") , "")
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(profileImage)
    contentView.addSubview(commentLabel)
    
    profileImage.snp.makeConstraints { (make) in
      make.left.right.top.equalToSuperview()
      make.height.equalTo(71)
    }
    
    commentLabel.snp.makeConstraints { (make) in
      make.top.equalTo(profileImage.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
    }
  
    contentView.backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct SectionOfCustomData {
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = UIImage?
  
  init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}
