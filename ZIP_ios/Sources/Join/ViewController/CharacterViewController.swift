//
//  CharacterViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 20..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

final class CharacterViewController: UIViewController, ProfileCompletor{
  
  
  private var selectedModel = [CharacterModel](){
    didSet{
      viewModel?.saver.accept(.character(value: selectedModel))
    }
  }
  
  weak var backSubject: PublishSubject<Void>?
  weak var completeSubject: PublishSubject<Void>?
  weak var viewModel: ProfileViewModel?
  
  private let disposeBag = DisposeBag()
  private var didUpdateContraint = false
  private let titleLabel: UILabel = {
    let attributeString = NSMutableAttributedString(string: "당신은 어떤 성격의\n사람인가요?\n\n",
                                                    attributes: [.font: UIFont.KoreanSWGI1R(size: 20),
                                                                 .foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1) ])
    attributeString.append(NSAttributedString(string: "선택에 따라 더 알맞은 친구를 소개받을 수 있어요!",
                                              attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 14),
                                                           .foregroundColor: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)]))
    
    let label = UILabel()
    label.attributedText = attributeString
    label.numberOfLines = 0
    return label
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 95, height: 54)
    layout.minimumLineSpacing = 15
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CharacterCollectionViewCell.self))
    collectionView.backgroundColor = .clear
    collectionView.allowsMultipleSelection = true
    return collectionView
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png"), for: .normal)
    return button
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
    view.addSubview(collectionView)
    view.addSubview(backButton)
    view.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
    
    collectionView.rx
      .modelSelected(CharacterModel.self)
      .subscribeNext(weak: self) { (weakSelf) -> (CharacterModel) -> Void in
        return { model in
          weakSelf.selectedModel.append(model)
        }
    }.disposed(by: disposeBag)
    
    collectionView
      .rx
      .modelDeselected(CharacterModel.self)
      .subscribeNext(weak: self) { (weakSelf) -> (CharacterModel) -> Void in
        return { model in
          for (i,m) in weakSelf.selectedModel.enumerated(){
            if m.id == model.id{
              weakSelf.selectedModel.remove(at: i)
              break
            }
          }
        }
    }.disposed(by: disposeBag)
    
    Observable<IndexPath>
      .merge([collectionView.rx.itemSelected.asObservable(),collectionView.rx.itemDeselected.asObservable()])
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> (IndexPath) -> Void in
        return { idx in
          guard let selectedItem = weakSelf.collectionView.indexPathsForSelectedItems else {return}
          weakSelf.nextButton.isEnabled = selectedItem.count >= 1
          weakSelf.nextButton.backgroundColor = (selectedItem.count >= 1) ? #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1) : #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
          //TODO: selected 아이템 전송
        }
    }.disposed(by: disposeBag)
    
    guard let model = viewModel,
      let subject = completeSubject,
      let back = backSubject else {return}
    
    model.getCharacters
      .catchError({ (error) -> Observable<[CharacterModel]?> in
        guard let err = error as? MoyaError else {return Observable.just([])}
        err.GalMalErrorHandler()
        return Observable.just([])
      })
      .unwrap()
      .bind(to: collectionView.rx.items(
        cellIdentifier: String(describing: CharacterCollectionViewCell.self),
        cellType: CharacterCollectionViewCell.self)){ idx, item, cell in
          cell.item = item
      }.disposed(by: disposeBag)
        
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
  
  override func updateViewConstraints() {
    if !didUpdateContraint{
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(79)
        make.left.equalToSuperview().inset(36)
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(10)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        make.width.height.equalTo(50)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(47)
        make.left.right.equalToSuperview().inset(31)
        make.bottom.equalToSuperview().inset(100)
      }
      
      nextButton.snp.makeConstraints { (make) in
        make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(11)
        make.height.equalTo(56)
      }
      
      didUpdateContraint = true
    }
    
    super.updateViewConstraints()
  }
}


final class CharacterCollectionViewCell: UICollectionViewCell{
  
  override var isSelected: Bool{
    didSet{
      if isSelected{
        titleButton.layer.borderWidth = 2
        titleButton.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1).cgColor
        titleButton.layer.cornerRadius = titleButton.frame.height/2
      }else {
        titleButton.layer.borderWidth = 0
      }
      titleButton.isSelected = isSelected
    }
  }
  
  var item: CharacterModel?{
    didSet{
      titleButton.setTitle(item?.typeName ?? String(), for: .normal)
    }
  }
  
  let titleButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 20)
    button.setTitleColor(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1), for: .selected)
    button.isUserInteractionEnabled = false
    button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleButton)
    
    titleButton.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
