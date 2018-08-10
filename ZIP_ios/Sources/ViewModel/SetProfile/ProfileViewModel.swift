//
//  ProfileViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import PopupDialog
import Moya
import Validator
import JDStatusBarNotification

enum ProfileType{
  case nickname(value: String)
  case birthDay(value: String)
  case gender(value: String)
  case tripStyle(value: [TripStyleModel])
  case interest(value:[InterestModel])
  case character(value:[CharacterModel])
  case introText(value: String)
  case image(value: [UIImage?])
  case overLapCheck(value: Bool)
}

enum ValidateError: Error{
  case empty(message: String)
  case length(message: String)
  case notEqual(message: String)
  var message: String {
    switch self {
    case .empty(let message),.length(let message),.notEqual(let message):
      return message
    }
  }
}

struct ProfileInput{
  var nickname = String()
  var birthDay = String()
  var gender = String()
  var tripStyle: [TripStyleModel] = []
  var interest: [InterestModel] = []
  var character:[CharacterModel] = []
  var introText = String()
  var images = [UIImage?](repeating: nil, count: 5)
  var overLapCheck = false
}

class ProfileViewModel{
  var item: UserModel?
  private let disposeBag = DisposeBag()
  
  let viewController: SetProfileViewController
  let modelSaver = PublishSubject<ProfileType>()
  var input = ProfileInput(){
    didSet{
      log.info(input)
    }
  }
  let profileAPI = AuthManager.provider.request(.user)
    .map(ResultModel<UserModel>.self)
    .retry(3)
    .asObservable()
    .share()
  
  lazy var getProfile = profileAPI
    .map{$0.result}
    .filterNil()
    .do(onNext: {(model) in
      self.item = model
    }).share()
  
  lazy var getTripType = profileAPI
    .map{$0.result?.profile?.tripType}
    .filterNil()
    .share()
  
  lazy var getInterestType = profileAPI
    .map{$0.result?.profile?.interestType}
    .filterNil()
    .share()
  
  lazy var getCharacterType = profileAPI
    .map{$0.result?.profile?.characterType}
    .filterNil()
    .share()
  
  
  init(viewController: SetProfileViewController) {
    self.viewController = viewController
    
    modelSaver.subscribe(onNext: { (type) in
      switch type{
      case .birthDay(let value):
        self.input.birthDay = value
      case .character(let value):
        self.input.character = value
      case .gender(let value):
        self.input.gender = value
      case .interest(let value):
        self.input.interest = value
      case .nickname(let value):
        self.input.nickname = value
        self.input.overLapCheck = false
      case .tripStyle(let value):
        self.input.tripStyle = value
      case .introText(let value):
        self.input.introText = value
      case .image(let value):
        self.input.images = value
      case .overLapCheck(let value):
        self.input.overLapCheck = value
      }
    }).disposed(by: disposeBag)
  }
  
  func valid() -> Bool{
    var nicknameRule = ValidationRuleSet<String>()
    nicknameRule.add(rule: ValidationRuleRequired(error: ValidateError.empty(message: "닉네임을 입력해주세요")))
    nicknameRule.add(rule: ValidationRuleLength(min:2, max:10, error: ValidateError.length(message:"닉네임 길이는 2자에서 10자까지 입니다.")))
    
    let nickNameResult = input.nickname.validate(rules: nicknameRule)
    let genderResult = input.gender.validate(rule: ValidationRuleRequired<String>(error: ValidateError.empty(message: "성별을 입력해 주세요")))
    let introTextResult = input.introText.validate(rule: ValidationRuleLength(min: 5, max: 20, lengthType: .utf8, error: ValidateError.length(message: "소개 길이는 5자 에서 20자 까지입니다.")))
    let tripTypeResult = input.tripStyle.validate(rule: TripStyleRule(error: ValidateError.length(message: "여행스타일을 하나이상 선택해 주세요.")))
    let interestResult = input.interest.validate(rule: InterestRule(error: ValidateError.length(message: "관심사를 하나이상 선택해 주세요.")))
    let characterResult = input.character.validate(rule: CharacterRule(error: ValidateError.length(message: "성격을 하나이상 선택해 주세요.")))
    let imageResult = input.images.validate(rule: ImageRule(error: ValidateError.length(message: "이미지는 하나이상 선택해야 합니다.")))
    
    var allResults = ValidationResult.merge(results: [nickNameResult,genderResult,introTextResult,
                                                      tripTypeResult,interestResult,characterResult,imageResult])
    if !input.overLapCheck{
      allResults = allResults.merge(with: ValidationResult.invalid([ValidateError.notEqual(message: "중복체크를 해야합니다")]))
    }
    
    switch allResults{
    case .invalid(let errors):
      errors.forEach {[unowned self] (error) in
        let temperror = error as! ValidateError
        self.errorPopUp(message: temperror.message)
      }
      return false
    case .valid:
      return true
    }
  }
  
  func commit(){
    if valid(){
      putProfile()
    }
  }
  
  
  func nickname(textField: UITextField){
    profileAPI
      .map{$0.result?.nickname}
      .filterNil()
      .subscribe(onNext: { (text) in
        textField.text = text
      }).disposed(by: disposeBag)
  }
  
  func overlapAPI(nickname: String){
    AuthManager.provider.request(.nicknameConfirm(nickname: nickname))
      .map(ResultModel<Bool>.self)
      .map{$0.result}
      .asObservable()
      .catchErrorJustReturn(false)
      .filterNil()
      .bind(onNext: profileAlertView)
      .disposed(by: disposeBag)
  }
  
  private func profileAlertView(result: Bool){
    var popup: PopupDialog!
    if result{
      popup = PopupDialog(title: "닉네임", message: "사용 가능합니다.")
      modelSaver.onNext(ProfileType.overLapCheck(value: true))
    }else{
      popup = PopupDialog(title: "닉네임", message: "사용 불가합니다.")
      modelSaver.onNext(ProfileType.overLapCheck(value: false))
    }
    let backButton = DefaultButton(title: "확인", height: 60, dismissOnTap: true, action: nil)
      popup.addButtons([backButton])
      viewController.present(popup, animated: true, completion: nil)
    }
  
  private func errorPopUp(message: String){
    let popup = PopupDialog(title: "확인", message: message)
    let backButton = DefaultButton(title: "확인", height: 60, dismissOnTap: true, action: nil)
    popup.addButtons([backButton])
    viewController.present(popup, animated: true, completion: nil)
  }
  
  private func putProfile(){
    
    var multiparts:[MultipartFormData] = []
    multiparts.append(MultipartFormData(provider: .data((input.gender.data(using: .utf8))!), name: "gender"))
    multiparts.append(MultipartFormData(provider: .data((input.birthDay.data(using: .utf8))!), name: "birthday"))
    multiparts.append(MultipartFormData(provider: .data((input.nickname.data(using: .utf8))!), name: "nickname"))
    
    for (idx,image) in input.images.enumerated(){
      if image != nil {
        multiparts.append(MultipartFormData(provider: .data(UIImageJPEGRepresentation(image!, 1)!), name: "image\(idx+1)", fileName: "image\(idx+1)", mimeType: "image/jpeg"))
      }
    }
    
    do {
      let tripJSON = try JSONEncoder().encode(input.tripStyle)
      let interestJSON = try JSONEncoder().encode(input.interest)
      let characterJSON = try JSONEncoder().encode(input.character)
      
      multiparts.append(MultipartFormData(provider: .data(tripJSON), name: "tripStyleType", fileName: "tripStyle.json", mimeType: nil))
      multiparts.append(MultipartFormData(provider: .data(interestJSON), name: "interestType", fileName: "interestType.json"))
      multiparts.append(MultipartFormData(provider: .data(characterJSON), name: "characterType", fileName: "characterType.json"))
     
    }catch let error {
      log.error(error)
    }
    
    AuthManager.provider.request(.createProfile(data: multiparts))
      .map(ResultModel<UserModel>.self)
      .subscribe(onSuccess: {[weak self] (result) in
        guard let `self` = self else {return}
        if result.success{
          JDStatusBarNotification.show(withStatus: "환영 합니다", dismissAfter: 2, styleName: JDType.Success.rawValue)
          self.viewController.navigationController?.popViewController(animated: true)
          AppDelegate.instance?.proxyController.makeRootViewController()
        }else{
          JDStatusBarNotification.show(withStatus: result.error?.details ?? "로그인 실패", dismissAfter: 1, styleName: JDType.Fail.rawValue)
        }
      }) { (error) in
        log.error(error)
      }.disposed(by: disposeBag)
  }
}


//MARK: - Rules
extension ProfileViewModel{
  struct ImageRule: ValidationRule{
    typealias InputType = [UIImage?]
    var error: Error
    func validate(input: [UIImage?]?) -> Bool {
      var count = 0
      for image in input!{
        if image != nil{
          count += 1
        }
      }
      return (count != 0) ? true : false
    }
  }
  
  struct TripStyleRule: ValidationRule {
    var error: Error
    func validate(input: [TripStyleModel]?) -> Bool {
      if input?.count != 0{
        return true
      }else{
        return false
      }
    }
    typealias InputType = [TripStyleModel]
  }
  
  struct InterestRule: ValidationRule {
    var error: Error
    func validate(input: [InterestModel]?) -> Bool {
      if input?.count != 0{
        return true
      }else{
        return false
      }
    }
    typealias InputType = [InterestModel]
  }
  
  struct CharacterRule: ValidationRule {
    var error: Error
    func validate(input: [CharacterModel]?) -> Bool {
      if input?.count != 0{
        return true
      }else{
        return false
      }
    }
    typealias InputType = [CharacterModel]
  }

}
