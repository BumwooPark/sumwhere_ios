//
//  InterestViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import SnapKit
import RxCocoa
import Moya
import RxDataSources
import JDStatusBarNotification
import NVActivityIndicatorView

final class TripStyleViewController: UIViewController, ProfileCompletor, NVActivityIndicatorViewable{
  
  private let disposeBag = DisposeBag()
  private var didUpdateContraint = false
  weak var backSubject: PublishSubject<Void>?
  weak var viewModel: ProfileViewModel?
  weak var completeSubject: PublishSubject<Void>?
  private var constraint: Constraint?
  private var remoteModel: [TripStyle]?
  var data = [SelectTripStyleModel]()
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    return scrollView
  }()
  
  let contentView: UIView = {
    let view = UIView()
    return view
  }()

  private let titleLabel: UILabel = {
    let attributeString = NSMutableAttributedString(string: "질문에 해당하는 항목을\n선택해주세요 \n\n",
                                                    attributes: [.font: UIFont.KoreanSWGI1R(size: 20),
                                                                 .foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1) ])
    attributeString.append(NSAttributedString(string: "당신의 여행스타일을 알기 위해 최대한 많이 선택해주세요.",
                                              attributes: [.font: UIFont.AppleSDGothicNeoLight(size: 14),
                                                           .foregroundColor: #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)]))
    
    let label = UILabel()
    label.attributedText = attributeString
    label.numberOfLines = 0
    return label
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TripStyleHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: TripStyleHeaderView.self))
    tableView.register(TripStyleCell.self, forCellReuseIdentifier: String(describing: TripStyleCell.self))
    tableView.separatorStyle = .none
    return tableView
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("등록완료", for: .normal)
    button.titleLabel?.font = .AppleSDGothicNeoMedium(size: 21)
    button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    button.layer.cornerRadius = 10
    button.isEnabled = false
    return button
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "backButton.png"), for: .normal)
    return button
  }()
  
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    self.data = [SelectTripStyleModel(
      title: "어떤 장소를 선호하시나요?",
      subTitle: "QUESTION 1 OF 3",
      datas: [.type(name: "카페", select: #imageLiteral(resourceName: "beforeCafe.png"), selected: #imageLiteral(resourceName: "afterCafe.png")),
              .type(name: "펍", select: #imageLiteral(resourceName: "beforePub.png"), selected: #imageLiteral(resourceName: "afterPub.png")),
              .type(name: "바다", select: #imageLiteral(resourceName: "beforeSea.png"), selected: #imageLiteral(resourceName: "afterSea.png")),
              .type(name: "산", select: #imageLiteral(resourceName: "beforeMountain.png"), selected: #imageLiteral(resourceName: "afterMountain.png")),
              .type(name: "공원", select: #imageLiteral(resourceName: "beforePark.png"), selected: #imageLiteral(resourceName: "afterPark.png")),
              .type(name: "호수", select: #imageLiteral(resourceName: "beforeLake.png"), selected: #imageLiteral(resourceName: "afterLake.png")),
              .type(name: "테마파크", select: #imageLiteral(resourceName: "beforeAmusementpark.png"), selected: #imageLiteral(resourceName: "afterAmusementpark.png")),
              .type(name: "전시회", select: #imageLiteral(resourceName: "beforeExhibition.png"), selected: #imageLiteral(resourceName: "afterExhibition.png")),
              .type(name: "포토존", select: #imageLiteral(resourceName: "beforePhotozone.png"), selected: #imageLiteral(resourceName: "afterPhotozone.png"))]
      ),
                 SelectTripStyleModel(
                  title: "어떤 투어스타일을 즐기시나요??",
                  subTitle: "QUESTION 2 OF 3",
                  datas: [.type(name: "명소", select: #imageLiteral(resourceName: "beforeAttraction.png"), selected: #imageLiteral(resourceName: "afterAttraction.png")),
                          .type(name: "야경", select: #imageLiteral(resourceName: "beforeNightview.png"), selected: #imageLiteral(resourceName: "afterNightview.png")),
                          .type(name: "먹방", select: #imageLiteral(resourceName: "beforeEat.png"), selected: #imageLiteral(resourceName: "afterEat.png")),
                          .type(name: "전시", select: #imageLiteral(resourceName: "beforeExibit.png"), selected: #imageLiteral(resourceName: "afterExibit.png")),
                          .type(name: "호캉스", select: #imageLiteral(resourceName: "beforeHotel.png"), selected: #imageLiteral(resourceName: "afterHotel.png")),
                          .type(name: "문화/체험", select: #imageLiteral(resourceName: "beforeCulture.png"), selected: #imageLiteral(resourceName: "afterCulture.png")),
                          .type(name: "쇼핑", select: #imageLiteral(resourceName: "beforeShopping.png"), selected: #imageLiteral(resourceName: "afterShopping.png")),
                          .type(name: "축제", select: #imageLiteral(resourceName: "beforeFestival.png"), selected: #imageLiteral(resourceName: "afterFestival.png")),
                          .type(name: "건강", select: #imageLiteral(resourceName: "beforeHealth.png"), selected: #imageLiteral(resourceName: "afterHealth.png"))]
                  ),
                 SelectTripStyleModel(
                  title: "어떤 액티비티를 좋아하시나요?",
                  subTitle: "QUESTION 3 OF 3",
                  datas: [.type(name: "드라이브", select: #imageLiteral(resourceName: "beforeDrive.png"), selected: #imageLiteral(resourceName: "afterDrive.png")),
                          .type(name: "스포츠", select: #imageLiteral(resourceName: "beforeSport.png"), selected: #imageLiteral(resourceName: "afterSport.png")),
                          .type(name: "수상레저", select: #imageLiteral(resourceName: "beforeWatersport.png"), selected: #imageLiteral(resourceName: "afterWatersport.png")),
                          .type(name: "지상레저", select: #imageLiteral(resourceName: "beforeLeisure.png"), selected: #imageLiteral(resourceName: "afterLeisure.png")),
                          .type(name: "항공레저", select: #imageLiteral(resourceName: "beforeSkyleisure.png"), selected: #imageLiteral(resourceName: "afterSkyleisure.png")),
                          .type(name: "캠핑/글램핑", select: #imageLiteral(resourceName: "beforeCamping.png"), selected: #imageLiteral(resourceName: "afterCamping.png")),
                          .type(name: "쿠킹클래스", select: #imageLiteral(resourceName: "beforeCooking.png"), selected: #imageLiteral(resourceName: "afterCooking.png")),
                          .type(name: "공예", select: #imageLiteral(resourceName: "beforeCraft.png"), selected: #imageLiteral(resourceName: "afterCraft.png")),
                          .type(name: "이색", select: #imageLiteral(resourceName: "beforeSpecial.png"), selected: #imageLiteral(resourceName: "afterSpecial.png"))])
                ]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(backButton)
    contentView.addSubview(titleLabel)
    contentView.addSubview(tableView)
    view.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
    
    guard let back = backSubject else {return}
    
    viewModel?
      .tripStyleAPI
      .elements()
      .subscribeNext(weak: self) { (weakSelf) -> ([TripStyle]) -> Void in
        return {model in
          weakSelf.remoteModel = model
        }
      }.disposed(by: disposeBag)
    
    
    backButton.rx
      .tap
      .bind(to: back)
      .disposed(by: disposeBag)
    
    
    guard let vm = viewModel else {return}
    
    let result = nextButton
      .rx
      .tap
      .debounce(0.2, scheduler: MainScheduler.instance)
      .do(onNext: { (_) in
        let activityData = ActivityData(size: CGSize(width: 50, height: 50),type: .circleStrokeSpin, color: #colorLiteral(red: 0.07450980392, green: 0.4823529412, blue: 0.7803921569, alpha: 1), backgroundColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
      })
      .flatMapLatest { (_) in
        return vm.putProfile()
      }.share()
    
    result.elements()
      .subscribeNext(weak: self) { (weakSelf) -> (Response) -> Void in
        return { _ in
          NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
          JDStatusBarNotification.show(withStatus: "환영 합니다", dismissAfter: 2, styleName: JDType.Success.rawValue)
          AppDelegate.instance?.window?.rootViewController = ProxyViewController()
        }
      }.disposed(by: disposeBag)
    
    result.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {error in
          (error as? MoyaError)?.GalMalErrorHandler()
        }
    }.disposed(by: disposeBag)
    
       
  }
  
//  Called by TripStyleSelectView
  func selectCountCheck(){
    for item in data{
      
      if item.selectedData.count < 3 {
        nextButton.isEnabled = false
        nextButton.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        return
      }
    }
    nextButton.isEnabled = true
    nextButton.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
    
    viewModel?.saver.accept(.tripStyle(model: self.remoteModel ?? [], targetModel: data))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let titleLabelHight = titleLabel.frame.height //+ 79 + 10
    constraint?.update(offset: tableView.contentSize.height + titleLabelHight)
  }
  
  override func updateViewConstraints() {
    if !didUpdateContraint{
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      contentView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
        make.width.equalTo(self.view)
        constraint = make.height.equalTo(self.view).constraint
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalTo(self.view).inset(10)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        make.width.height.equalTo(50)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().inset(79)
        make.left.equalToSuperview().inset(36)
      }
      
      tableView.snp.makeConstraints { (make) in
        make.bottom.left.right.equalToSuperview()
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
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

extension TripStyleViewController: UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].isSelected ? 1 : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TripStyleCell.self), for: indexPath) as! TripStyleCell
    cell.item = data[indexPath.section]
    
    return cell
  }
}

extension TripStyleViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: TripStyleHeaderView.self)) as! TripStyleHeaderView
    view.item = data[section]
    
    view.selectedButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.present(TripStyleSelectViewController(model: weakSelf.data[section],PVC: weakSelf), animated: true, completion: nil)
        }
    }.disposed(by: view.disposeBag)
    

    
    return view
  }
  
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}
