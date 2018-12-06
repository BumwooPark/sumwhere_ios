//
//  OneTimeMatchViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 16/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import IGListKit
import MXParallaxHeader
import RxSwift
import RxCocoa
import TTTAttributedLabel
import PopupDialog

class OneTimeMatchViewController: UIViewController, ListAdapterDataSource{
  let viewModel: TripViewModel
  private let disposeBag = DisposeBag()
  
  private lazy var resetLabel: TTTAttributedLabel = {
    let label = TTTAttributedLabel(frame: .zero)
    let attstring = NSMutableAttributedString(string: "매칭하고 싶은 친구가 없나요?",attributes: [.font : UIFont.AppleSDGothicNeoRegular(size: 14)])
    label.attributedText = attstring
    label.linkAttributes = [kCTForegroundColorAttributeName:#colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1),kCTUnderlineColorAttributeName:#colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1),kCTUnderlineStyleAttributeName: NSNumber(value: CTUnderlineStyle.single.rawValue)]
//    label.activeLinkAttributes = [kCTForegroundColorAttributeName:#colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)]
//    label.inactiveLinkAttributes = [kCTForegroundColorAttributeName:#colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)]
    label.delegate = self
    let range = NSRange(location: 0, length: "매칭하고 싶은 친구가 없나요?".count)
    label.addLink(to: URL(fileURLWithPath: ""), with: range)
    return label
  }()
  
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    return adapter
  }()
  
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return [1] as [ListDiffable]
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return OneTimeSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    let emptyView = MatchEmptyView()
    emptyView.addButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          let tripView = CreateOneTimeViewController()
          weakSelf.present(tripView, animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    return emptyView
  }
  
  lazy var collectionView: UICollectionView = {
    
    let layout = CardCollectionViewLayout()
    layout.itemSize = CGSize(width: 306, height: 380)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true
    collectionView.isPagingEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    let emptyView = UIImageView()
    emptyView.image = #imageLiteral(resourceName: "bridge")
    emptyView.contentMode = .scaleAspectFill
    collectionView.parallaxHeader.view = emptyView
    collectionView.parallaxHeader.height = UIScreen.main.bounds.height
    collectionView.parallaxHeader.minimumHeight = 0
    collectionView.parallaxHeader.mode = .fill
    collectionView.alwaysBounceVertical = true
    parallaxHeader?.delegate = self
    return collectionView
  }()
  
  init(_ viewModel: TripViewModel){
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    view.addSubview(resetLabel)
    _ = adapter
    
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    
    resetLabel.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(21)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(27)
    }
    
//    Observable.of(collectionView.rx.didEndDecelerating
//      .map{_ in return ()},collectionView.rx.didEndDragging.map{_ in return ()})
//      .merge()
//      .observeOn(MainScheduler.asyncInstance)
//      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
//        return { _ in
//          if weakSelf.collectionView.contentOffset.y < -(weakSelf.collectionView.frame.height - 200){
//            weakSelf.collectionView.setContentOffset(CGPoint(x: 0, y: -(weakSelf.collectionView.frame.height)), animated: true)
//          }else{
//            weakSelf.collectionView.setContentOffset(CGPoint.zero, animated: true)
//          }
//        }
//    }.disposed(by: disposeBag)
  }
}


extension OneTimeMatchViewController: MXParallaxHeaderDelegate{
  func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {

  }
}

extension OneTimeMatchViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.titleFont = UIFont.AppleSDGothicNeoRegular(size: 16)
    dialogAppearance.titleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    dialogAppearance.messageFont = UIFont.AppleSDGothicNeoBold(size: 16)
    dialogAppearance.messageColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    let popup = PopupDialog(title: "매칭하고 싶은 친구가 없으면\n 새로운 친구를 추천해드릴게요!", message: "키 1개가 사용됩니다.",buttonAlignment: .horizontal,transitionStyle: .zoomIn,
                            tapGestureDismissal: true,
                            panGestureDismissal: true)
    
    
    popup.addButtons([Init(CancelButton(title: "취소", action: nil)){ (bt) in
      bt.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
      },Init(DefaultButton(title: "확인", action: nil)){ (bt) in
        bt.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
      }])
    self.present(popup, animated: true, completion: nil)
  }
}
