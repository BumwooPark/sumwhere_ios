//
//  회원이 아닐경우 맨처음 보이는 ViewController
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import AVFoundation
import AVKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxKeyboard
#endif

class WelcomeViewController: UIViewController{
  
  private var didUpdateConstraint = false
  let disposeBag = DisposeBag()
  let joinVC = JoinViewController()
  lazy var viewModel = LoginViewModel(viewController: self)
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  let avPlayerController: AVPlayerViewController = {
    let controller = AVPlayerViewController()
    controller.player = AVPlayer(url: Bundle.main.url(forResource: "mainlogo", withExtension: "mp4")!)
    controller.showsPlaybackControls = false
    controller.player?.actionAtItemEnd = .none
    controller.videoGravity = .resizeAspectFill
    controller.player?.play()
    return controller
  }()
  
  lazy var loginView: LoginView = {
    let view = LoginView.loadXib(nibName: "LoginView") as! LoginView
    view.backgroundColor = .clear
    return view
  }()
  
  override func loadView() {
    super.loadView()
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.addSubview(avPlayerController.view)
    self.view.addSubview(loginView)
    self.view.hero.id = "loginToDefaultLogin"
    
    NotificationCenter
      .default
      .rx
      .notification(.AVPlayerItemDidPlayToEndTime, object: avPlayerController.player?.currentItem)
      .subscribeNext(weak: self) { (weakSelf) -> (Notification) -> Void in
        return {noti in
          let currentVideo = noti.object as? AVPlayerItem
          currentVideo?.seek(to: .zero, completionHandler: nil)
        }
    }.disposed(by: disposeBag)
    
    NotificationCenter
      .default
      .rx
      .notification(UIApplication.didBecomeActiveNotification)
      .subscribeNext(weak: self) { (weakSelf) -> (Notification) -> Void in
        return {_ in
          weakSelf.avPlayerController.player?.play()
        }
      }.disposed(by: disposeBag)
    
    
    loginView.emailButton.rx
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
    
    loginView.signUpButton.rx
      .tap
      .bind(onNext: signUp)
      .disposed(by: disposeBag)
    
    
    self.view.setNeedsUpdateConstraints()
    
  }
  
  override func updateViewConstraints() {
    if !didUpdateConstraint{
      
      avPlayerController.view.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      loginView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      
      didUpdateConstraint = true
    }
    super.updateViewConstraints()
  }
  
  private func signIn(){
    self.navigationController?.pushViewController(DefaultLoginViewController(), animated: true)
  }
  
  private func signUp(){
    self.navigationController?.pushViewController(JoinViewController(), animated: true)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
