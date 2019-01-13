//
//  TripStyleSelectViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 19/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa


class TripStyleSelectViewController: UIViewController {
  
  var item: SelectTripStyleModel
  let PVC: TripStyleViewController
  private let contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 10
    view.layer.masksToBounds = true
    return view
  }()
  
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let submitButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "before.png"), for: .normal)
    return button
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 73, height: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(TripSelectCell.self, forCellWithReuseIdentifier: String(describing: TripSelectCell.self))
    collectionView.backgroundColor = .white
    collectionView.allowsMultipleSelection = true 
    return collectionView
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIView.animate(withDuration: 0.5) {[weak self] in
      self?.presentingViewController?.view.alpha = 0.65
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIView.animate(withDuration: 0.5) {[weak self] in
      self?.presentingViewController?.view.alpha = 1.0
    }
  }
  
  init(model: SelectTripStyleModel, PVC: TripStyleViewController) {
    self.item = model
    self.PVC = PVC
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overCurrentContext
    let attributedString = NSMutableAttributedString(string: model.title + "\n", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 17.6)])
    attributedString.append(NSAttributedString(string: "세개이상 선택해주세요", attributes: [.font: UIFont.AppleSDGothicNeoSemiBold(size: 13.2),.foregroundColor: #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)]))
    titleLabel.attributedText = attributedString
    
    Observable
      .just(model.datas)
      .bind(to: collectionView.rx.items(cellIdentifier: String(describing: TripSelectCell.self), cellType: TripSelectCell.self)){ idx,item,cell in
        cell.item = item
      }.disposed(by: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(contentView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(collectionView)
    contentView.addSubview(submitButton)
    
    collectionView
      .rx
      .modelSelected(SelectTripStyleModel.TripType.self)
      .subscribeNext(weak: self) { (weakSelf) -> (SelectTripStyleModel.TripType) -> Void in
        return {model in
          weakSelf.item.selectedData.append(model)
          weakSelf.item.isSelected = weakSelf.item.selectedData.count > 0
        }
      }.disposed(by: disposeBag)
    
    collectionView.rx
      .modelDeselected(SelectTripStyleModel.TripType.self)
      .subscribeNext(weak: self) { (weakSelf) -> (SelectTripStyleModel.TripType) -> Void in
        return {model in
          for (idx,item) in weakSelf.item.selectedData.enumerated(){
            if item == model{
              weakSelf.item.selectedData.remove(at: idx)
              weakSelf.item.isSelected = weakSelf.item.selectedData.count > 0
              return
            }
          }
        }
    }.disposed(by: disposeBag)
    
    item.datas.enumerated().forEach { (offset,element) in
      item.selectedData.forEach({[unowned self] (selected) in
        if element == selected {
          self.collectionView.selectItem(at: IndexPath(row: offset, section: 0), animated: true, scrollPosition: .bottom)
        }
      })
    }
        
    submitButton
      .rx
      .tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.PVC.tableView.reloadData()
          weakSelf.PVC.selectCountCheck()
          weakSelf.dismiss(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      contentView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview().inset(UIEdgeInsets(top: 72, left: 24, bottom: 72, right: 24))
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.equalToSuperview().inset(30)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(30)
        make.left.right.equalToSuperview().inset(20)
        make.bottom.equalTo(submitButton.snp.top).inset(30)
      }
      
      submitButton.snp.makeConstraints { (make) in
        make.bottom.equalToSuperview().inset(12.5)
        make.left.right.equalToSuperview().inset(14.5)
        make.height.equalTo(53.8)
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}
