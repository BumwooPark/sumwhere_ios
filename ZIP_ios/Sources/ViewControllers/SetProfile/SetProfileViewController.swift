////
////  SetProfileViewController.swift
////  ZIP_ios
////
////  Created by park bumwoo on 2018. 2. 14..
////  Copyright © 2018년 park bumwoo. All rights reserved.
////
//
//import UIKit
//import Eureka
//import TLPhotoPicker
//import RxCocoa
//import RxSwift
//import RxGesture
//import SwiftDate
//import Moya
//
//
//class SetProfileViewController: FormViewController{
//  let disposeBag = DisposeBag()
//
//  var item: UserModel?
//  var images = [UIImage?](repeating: nil, count: 5)
//  let configure: Bool
//
//  lazy var viewModel = SetProfileViewModel(viewController: self)
//
//  let lastSection = Section()
//
//  init(config: Bool) {
//    configure = config
//    super.init(nibName: nil, bundle: nil)
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    viewModel
//      .getProfile
//      .subscribe { (event) in
//      switch event{
//      case .next(_):
//        for row in self.form.rows{
//          row.updateCell()
//        }
//        self.tableView.reloadData()
//      case .error(let error):
//        log.error(error)
//      case .completed:
//        log.info("completed")
//      }
//      }.disposed(by: disposeBag)
//
//    self.tableView.backgroundColor = .white
//    title = "프로필 등록"
//    navigationItem.largeTitleDisplayMode = .always
//
//    form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
//    form
//      +++ Section(){ section in
//        section.tag = "headersection"
//        var header = HeaderFooterView<ProfileHeaderView>(.class)
//        header.height = {100}
//        header.onSetupView = {[unowned self] view, _ in
//          view.backgroundColor = .white
//          view.viewController = self
//        }
//        section.header = header
//      }
//
//      +++ Section("프로필")
//
//      <<< NicknameRow(){
//        $0.title = "닉네임"
//        $0.tag = "nickname"
//        }.cellSetup({[weak self] (cell, row) in
//          guard let `self` = self else {return}
//          cell.checkButton.rx.tap
//            .map{cell.textField.text}
//            .filterNil()
//            .bind(onNext: self.viewModel.overlapAPI)
//            .disposed(by: self.disposeBag)
//
//          cell.textField.rx.text
//            .filterNil()
//            .map{ProfileType.nickname(value: $0)}
//            .bind(to: self.viewModel.modelSaver)
//            .disposed(by: self.disposeBag)
//
//        }).cellUpdate({ (cell, row) in
//          log.info("update")
//          row.cell.textField.text = self.item?.nickname
//        })
//
//      <<< DateInlineRow(){
//        $0.title = "생년월일"
//        $0.tag = "birthday"
//        }.cellSetup({ (cell, row) in
//          cell.textLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//          cell.detailTextLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//        }).cellUpdate({[weak self] (cell, row) in
//          if self?.viewModel.item?.profile?.birthday == String(){
//            row.value = Date(timeIntervalSinceNow: 0)
//          }else{
//            row.value = self?.viewModel.item?.profile?.birthday.toISODate()?.date
//          }
//        }).onChange({[weak self] (row) in
//          guard let `self` = self else {return}
//          self.viewModel.modelSaver.onNext(.birthDay(value: (row.value?.toFormat("yyyy-MM-dd"))!))
//        })
//
//      <<< PickerInlineRow<String>(){
//        $0.title = "성별"
//        $0.tag = "gender"
//        $0.options = ["여성","남성"]
//        }.cellSetup({ (cell, row) in
//          cell.textLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//          cell.detailTextLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//        }).cellUpdate({[weak self] (cell, row) in
//          row.value = self?.viewModel.item?.gender
//        }).onChange({[weak self] (row) in
//          guard let `self` = self else {return}
//          self.viewModel.modelSaver.onNext(.gender(value: row.value!))
//        })
//
//      +++ Section("스타일")
//
////      <<< TripStylePresenterRow(){
////        $0.title = "여행스타일"
////        $0.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {[unowned self] in
////          return TripStyleViewController(viewModel: self.viewModel)
////        }), onDismiss: {[weak self] vc in
////          guard let `self` = self, let tripvc = vc as? TripStyleViewController else {return}
////          self.viewModel.modelSaver.onNext(.tripStyle(value: tripvc.selectedModel))
////          _ = vc.navigationController?.popViewController(animated: true)
////        })}.cellSetup({ (cell, row) in
////          cell.textLabel?.font = UIFont.NotoSansKRMedium(size: 15)
////          cell.detailTextLabel?.font = UIFont.NotoSansKRMedium(size: 15)
////        })
//
//      <<< InterestPresenterRow(){
//        $0.title = "관심사"
//        $0.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {[unowned self] in
//          return InterestSelectViewController2(viewModel: self.viewModel)
//        }), onDismiss: {[weak self] vc in
//          guard let `self` = self ,let intervc = vc as? InterestSelectViewController2 else {return}
//          self.viewModel.modelSaver.onNext(.interest(value: intervc.selectedModel))
//          _ = vc.navigationController?.popViewController(animated: true)
//        })
//        }.cellSetup({ (cell, row) in
//          cell.textLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//          cell.detailTextLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//        })
//
//      <<< CharacterPresenterRow(){
//        $0.title = "성격"
//        $0.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {[unowned self] in
//          return CharacterViewController2(viewModel: self.viewModel)
//        }), onDismiss: {[weak self]vc in
//          guard let `self` = self ,let charvc = vc as? CharacterViewController2 else {return}
//          self.viewModel.modelSaver.onNext(.character(value: charvc.selectedModel))
//          _ = vc.navigationController?.popViewController(animated: true)
//        })
//        }.cellSetup({ (cell, row) in
//          cell.textLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//          cell.detailTextLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//        })
//
//      +++ Section("자기소개")
//      <<< TextAreaRow().cellSetup({[unowned self] (cell, row) in
//        cell.textView
//          .rx
//          .text
//          .filterNil()
//          .subscribe(onNext: {(text) in
//            self.viewModel.modelSaver.onNext(.introText(value: text))
//          }).disposed(by: self.disposeBag)
//      })
//
//      +++ lastSection
//      <<< ButtonRow(){
//        $0.title = "완료"
//        }.onCellSelection({ [weak self](cell, row) in
//          self?.viewModel.commit()
//        }).cellSetup({ (button, row) in
//          button.textLabel?.font = UIFont.NotoSansKRMedium(size: 15)
//          button.tintColor = .black
//        })
//  }
//
//  func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection: Int) {
//
//    if let view = view as? UITableViewHeaderFooterView {
//      view.textLabel?.font = UIFont.NotoSansKRMedium(size: 16)
//    }
//  }
//}
