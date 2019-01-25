//
//  CreateTripViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import PopupDialog
import Moya

final class CreateScheduleTripViewController: UIViewController{
  
  let viewModel = RegisterTripViewModel()
  
  private var didUpdateConstraint = false
  private let disposeBag = DisposeBag()
  
  private let pageView: PageViewController
  
  init() {
//    let searchVC = SearchDestinationViewController(viewModel: viewModel)
    let planVC = InsertPlanViewController(viewModel: viewModel)
    let completeVC = RegisterViewController(viewModel: viewModel)
    _ = planVC.view
    _ = completeVC.view
    self.pageView = PageViewController(pages: [planVC,completeVC], spin: false)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    pageView.isPagingEnabled = false
    self.addChild(pageView)
    view.addSubview(pageView.view)
    view.setNeedsUpdateConstraints()
    self.navigationController?.navigationBar.topItem?.title = String()
    rxBinder()
  }
  
  private func rxBinder(){
    viewModel
      .dismissAction
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.dismiss(animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    viewModel
      .backAction
      .bind(onNext: pageView.scrollToAutoBackward)
      .disposed(by: disposeBag)
    
    viewModel
      .scrollToFirst
      .subscribeNext(weak: self) { (weakSelf) -> (()) -> Void in
        return {_ in
          weakSelf.pageView.scrollToViewController(index: 0)
        }
      }.disposed(by: disposeBag)
  }
  
  
  //MARK: - 여행 계획 등록
//  func register(){
//
//    if let err = viewModel.validate(){
//      switch err{
//      case .date(let message):
//        JDStatusBarNotification.show(withStatus: message, dismissAfter: 2, styleName: JDType.Fail.rawValue)
//        pageView.scrollToViewController(index: 1)
//      case .destination(let message):
//        JDStatusBarNotification.show(withStatus: message, dismissAfter: 2, styleName: JDType.Fail.rawValue)
//        pageView.scrollToViewController(index: 0)
//      }
//    }else {
//      viewModel
//        .createTrip()
//        .subscribe(onSuccess: { (model) in
//          if model.success{
//            JDStatusBarNotification.show(withStatus: "등록되었습니다", dismissAfter: 2, styleName: JDType.Success.rawValue)
//            self.dismiss(animated: true, completion: nil)
//          }else{
//            JDStatusBarNotification.show(withStatus: model.error?.details ?? String(), dismissAfter: 2, styleName: JDType.Fail.rawValue)
//          }
//      }) { (error) in
//        log.error(error)
//      }.disposed(by: disposeBag)
//    }
//  }
  
  //MARK: - 여행 validation 체크
  func validationErrorPopUp(error: Error){
    var popup: PopupDialog!
    
    if case .requestMapping(let message) = error as! MoyaError{
      popup = PopupDialog(title: "중복", message: message)
    }else{
      popup = PopupDialog(title: "에러", message: "관리자에게 문의 바랍니다.")
    }
    
    let confirmButton = DefaultButton(title: "확인", height: 60, dismissOnTap: true, action: nil)
    popup.addButtons([confirmButton])
    self.present(popup, animated: true, completion: nil)
  }

  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      pageView.view.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
}

