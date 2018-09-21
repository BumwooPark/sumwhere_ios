//
//  CharacterViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 20..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift

final class CharacterViewController: UIViewController, ProfileCompletor{
  
  let data = ["활발한","조용한","소심한","현명한","4차원","성숙한","단순한","조심스러운","쿨한","재밋는","츤데레","친절한","관대한","꼼꼼한","여린"]
  weak var completeSubject: PublishSubject<Void>?
  weak var viewModel: SetProfileViewModel?
  
  private let disposeBag = DisposeBag()
  private var didUpdateContraint = false
  private let titleLabel: UILabel = {
    let attributeString = NSMutableAttributedString(string: "당신은 어떤 성격의\n사람인가요?\n",
                                                    attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 20),
                                                                 .foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1) ])
    attributeString.append(NSAttributedString(string: "최소 하나 이상 선택해 주세요",
                                              attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 14),
                                                           .foregroundColor: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)]))
    
    let label = UILabel()
    label.attributedText = attributeString
    label.numberOfLines = 3
    return label
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 95, height: 54)
    layout.minimumLineSpacing = 15
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CharacterCollectionViewCell.self))
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(titleLabel)
    view.addSubview(collectionView)
    view.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
    
    Observable.just(data)
      .bind(to: collectionView.rx.items(
        cellIdentifier: String(describing: CharacterCollectionViewCell.self),
        cellType: CharacterCollectionViewCell.self)){ idx, item, cell in
          
        cell.item = item
    }.disposed(by: disposeBag)
  }

  override func updateViewConstraints() {
    if !didUpdateContraint{
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(79)
        make.left.equalToSuperview().inset(36)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(47)
        make.left.right.equalToSuperview().inset(31)
        make.bottom.equalToSuperview().inset(100)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        make.height.equalTo(61)
      }
      
      didUpdateContraint = true
    }
    
    super.updateViewConstraints()
  }
}


final class CharacterCollectionViewCell: UICollectionViewCell{
  
  var item: String?{
    didSet{
      titleLabel.text = item
    }
  }
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .AppleSDGothicNeoLight(size: 20)
    label.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
    return label
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
