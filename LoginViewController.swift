//
//  회원이 아닐경우 맨처음 보이는 ViewController
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField
import SnapKit
import Moya
import SwiftyJSON
import JDStatusBarNotification
import Firebase
import Security
import FBSDKLoginKit
import SwiftyUserDefaults
import TTTAttributedLabel
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxKeyboard
#endif

class LoginViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let joinVC = JoinViewController()
  lazy var viewModel = LoginViewModel(viewController: self)
  
  lazy var loginView: LoginView = {
    let view = LoginView(frame: self.view.bounds)
    view.joinLabel.delegate = self
    return view
  }()
  
  override func loadView() {
    super.loadView()
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = loginView
    self.view.hero.id = "loginToDefaultLogin"
    
    loginView.loginButton.rx
      .tap
      .bind(onNext: signIn)
      .disposed(by: disposeBag)

    loginView.kakaoButton.rx
      .controlEvent(.touchUpInside)
      .throttle(0.3, scheduler: MainScheduler.instance)
      .bind(onNext: viewModel.kakaoLogin)
      .disposed(by: disposeBag)
    
    loginView.faceBookButton.rx
      .tap
      .map {return FBSDKLoginManager()}
      .bind(onNext: viewModel.facebookLogin)
      .disposed(by: disposeBag)
  }
  
  private func signIn(){
    present(DefaultLoginViewController(), animated: true, completion: nil)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
  
  
  
extension LoginViewController: TTTAttributedLabelDelegate{
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    present(JoinViewController(), animated: true, completion: nil)
  }
}
