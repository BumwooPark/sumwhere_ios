//
//  File.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKLoginKit
import FLAnimatedImage

final class LoginView: UIView{
  @IBOutlet weak var faceBookButton: UIButton!
  @IBOutlet weak var kakaoButton: UIButton!
  @IBOutlet weak var emailButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
