//
//  WriteViewController.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 26..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


final class WriteViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  
  let button: UIButton = {
    let button = UIButton()
    button.setTitle("글쓰기", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(button)
    
    button.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
    
    button.rx.tap
      .bind {print("tap")}
      .disposed(by: disposeBag)
  }
}
