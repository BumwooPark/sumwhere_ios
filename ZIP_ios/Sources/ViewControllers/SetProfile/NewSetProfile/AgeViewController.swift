//
//  AgeViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 20..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

final class AgeViewController: UIViewController, ProfileCompletor{
  private let disposeBag = DisposeBag()
  
  var completeSubject: PublishSubject<Void>?
  private var didUpdateContraint = false
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "나이를 선택해주세요."
    label.font = .AppleSDGothicNeoMedium(size: 20)
    label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    return label
  }()
  
  private lazy var pickerView: UIPickerView = {
    let pickerView = UIPickerView()
    return pickerView
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
    view.addSubview(pickerView)
    view.addSubview(nextButton)
    view.setNeedsUpdateConstraints()
    
    Observable.just([[Int](10...80)])
      .bind(to: pickerView.rx.items(adapter: PickerViewViewAdapter()))
      .disposed(by: disposeBag)
    
    pickerView.rx.modelSelected(Int.self)
      .subscribe(onNext: { models in
        print(models)
      })
      .disposed(by: disposeBag)
    
    
    
    
    pickerView.rx
      .itemSelected
      .subscribeNext(weak: self, { (weakSelf) -> ((Int,Int)) -> Void in
        return { data in
          guard let label = weakSelf.pickerView.view(forRow: data.0, forComponent: data.1) as? UILabel else {return}
          let attributeString = NSMutableAttributedString(string: label.text ?? String(), attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 30)])
          attributeString.append(NSAttributedString(string: " 세", attributes: [.font: UIFont.AppleSDGothicNeoMedium(size: 20)]))
          label.attributedText = attributeString
          label.textColor = #colorLiteral(red: 0.3176470588, green: 0.4784313725, blue: 0.8941176471, alpha: 1)
        }
      }).disposed(by: disposeBag)
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {[weak self] in
      self?.completeSubject?.onNext(())
    }
  }
  
  override func updateViewConstraints() {
    if !didUpdateContraint{
      
      titleLabel.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview().inset(-200)
        make.left.equalToSuperview().inset(41)
      }
      
      pickerView.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.left.right.equalToSuperview().inset(40)
        make.height.equalTo(300)
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

final class PickerViewViewAdapter
  : NSObject
  , UIPickerViewDataSource
  , UIPickerViewDelegate
  , RxPickerViewDataSourceType
, SectionedViewDataSourceType {
  typealias Element = [[CustomStringConvertible]]
  private var items: [[CustomStringConvertible]] = []
  
  func model(at indexPath: IndexPath) throws -> Any {
    return items[indexPath.section][indexPath.row]
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return items.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return items[component].count
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let label = UILabel()
    label.text = items[component][row].description
    label.textColor = #colorLiteral(red: 0.7725490196, green: 0.7725490196, blue: 0.7725490196, alpha: 1)
    label.font = UIFont.AppleSDGothicNeoMedium(size: 30)
    label.textAlignment = .center
    return label
  }
  
  func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
    Binder(self) { (adapter, items) in
      adapter.items = items
      pickerView.reloadAllComponents()
      }.on(observedEvent)
  }
}
