//
//  SearchDestinationViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 28..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxDataSources
import RxCocoa
import RxSwift

class SearchDestinationViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  var didUpdateConstraint = false
  
  private let viewModel: RegisterTripViewModel
  
  private let contentView = UIView()
  private let gradientView = UIView()
  
  lazy var dataSources = RxTableViewSectionedReloadDataSource<SearchDestTVModel>(configureCell: {[weak self] (ds, tv, idx, item) -> UITableViewCell in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: DestinationSearchCell.self), for: idx) as! DestinationSearchCell
    cell.item = (item,self?.textField.text)
    return cell
  })
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .clear
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.keyboardDismissMode = .interactive
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
    return scrollView
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "어디로 떠날까요?"
    label.font = .KoreanSWGI1R(size: 30)
    return label
  }()
  
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "popupDismiss.png").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  lazy var textField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(
      string: "여행지를 입력해 주세요",
      attributes: [.font : UIFont.AppleSDGothicNeoMedium(size: 15)])
    let leftView = UIImageView(image: #imageLiteral(resourceName: "searchIcon.png"), highlightedImage: nil)
    leftView.contentMode = .scaleAspectFit
    leftView.frame = CGRect(origin: .zero, size: CGSize(width: 25, height: 18))
    textField.leftView = leftView
    textField.leftViewMode = .always
    textField.font = .AppleSDGothicNeoMedium(size: 15)
    textField.setZIPClearButton()
    textField.clearButtonMode = .never
    textField.backgroundColor = .white
    textField.delegate = self
    return textField
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.isScrollEnabled = false
    tableView.separatorStyle = .none
    tableView.register(DestinationSearchCell.self, forCellReuseIdentifier: String(describing: DestinationSearchCell.self))
    return tableView
  }()
  
  
  init(viewModel: RegisterTripViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(tableView)
    contentView.addSubview(textField)
    contentView.addSubview(backButton)
    contentView.addSubview(titleLabel)
    contentView.addSubview(gradientView)
    view.backgroundColor = .white
    hideKeyboardWhenTappedAround()
    
    textField.rx
      .text
      .orEmpty
      .ignore(String())
      .bind(to: viewModel.tripPlaceBinder)
      .disposed(by: disposeBag)
    
    scrollView.rx.contentOffset
      .filter{$0.y <= 55}
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> (CGPoint) -> Void in
        return { point in
          weakSelf.titleLabel.alpha = (55 - point.y)/55
        }
      }.disposed(by: disposeBag)
    
    scrollView.rx.contentOffset
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> (CGPoint) -> Void in
        return { point in
          if point.y >= 60 {
            weakSelf.textField.snp.remakeConstraints({ (make) in
              make.left.right.equalToSuperview().inset(16)
              make.top.equalTo(weakSelf.backButton.snp.bottom)
              make.height.equalTo(46)
            })
          }else{
            weakSelf.textField.snp.remakeConstraints { (make) in
              make.left.right.equalToSuperview().inset(16)
              make.top.equalTo(weakSelf.titleLabel.snp.bottom).offset(20)
              make.height.equalTo(46)
            }
          }
          weakSelf.view.setNeedsLayout()
        }
      }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(TripType.self)
      .subscribeNext(weak: self) { (weakSelf) -> (TripType) -> Void in
        return {type in
          weakSelf.viewModel.saver.accept(RegisterTripViewModel.SaveType.place(model: type))
          weakSelf.viewModel.completeAction.onNext(())
        }
      }.disposed(by: disposeBag)
    
    viewModel.tripPlaceMapper
      .map{[SearchDestTVModel(items: $0)]}
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    backButton.rx.tap
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.dismiss(animated: true, completion: nil)
        }
      }.disposed(by:disposeBag)
    
    view.setNeedsUpdateConstraints()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    gradientView.gradientBackground(from: #colorLiteral(red: 0.2941176471, green: 0.5725490196, blue: 1, alpha: 1), to: #colorLiteral(red: 0.6352941176, green: 0.4784313725, blue: 1, alpha: 1), direction: GradientDirection.leftToRight)
  }
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      scrollView.snp.makeConstraints { (make) in
        make.edges.equalTo(self.view.safeAreaLayoutGuide)
      }
      
      contentView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
        make.width.equalTo(self.view)
        make.height.equalTo(1000)
      }
      
      titleLabel.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(23)
        make.top.equalToSuperview().inset(81)
      }
      
      textField.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview().inset(16)
        make.top.equalTo(titleLabel.snp.bottom).offset(20)
        make.height.equalTo(46)
      }
      
      gradientView.snp.makeConstraints { (make) in
        make.left.right.equalTo(textField)
        make.top.equalTo(textField.snp.bottom)
        make.height.equalTo(2)
      }
      
      backButton.snp.makeConstraints { (make) in
        make.left.equalToSuperview().inset(16)
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(25)
        make.width.height.equalTo(40)
      }
      
      tableView.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(65)
        make.left.right.bottom.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

extension SearchDestinationViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}
