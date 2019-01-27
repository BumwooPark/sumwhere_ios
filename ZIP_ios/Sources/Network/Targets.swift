//
//  Targets.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Moya

public enum ZIP{
  
  case signUp(model: Encodable)
  case signIn(email: String, password: String)
  case tokenLogin
  case facebook(access_token: String)
  case kakao(access_token: String)
  case nicknameConfirm(nickname: String)
  case isProfile
  case country
  case GetAllTrip(order: String, sortby: String, skipCount: Int)
  case createProfile(data: [MultipartFormData])
  case user
  case anotherUser(id: String)
  case userWithProfile(id: String?)
  case createTrip(model: Encodable)
  case myTrip
  case deleteMyTrip(id: Int)
  case searchDestination(data: String)
  case AllTripList(sortby: String, order: String, skipCount: Int, maxResultCount: Int)
  case GetAllTripStyle
  case GetAllInterest
  case GetAllCharacter
  case TripDateValidate(start: String, end: String)
  case TripDestinationValidate(id: Int)
  case RelationShipMatch(tripId: Int, startDate: String, endDate: String)
  case MatchRequest(model: Encodable)
  case MatchRequestReceive
  case MatchRequestSend
  case MatchType
  case GetChatRoom
  case IAPList
  case IAPInfo(productName: String)
  case IAPSuccess(receipt: String, identifier: String)
  case purchaseHistory(pageNum: Int)
  case event
  case Notice
  case banner
  case SignOut
  case GetPush
  case UpdatePush(model: Encodable)
  case FcmUpdate(token: String)
}

extension ZIP: TargetType, AccessTokenAuthorizable{

  public var baseURL: URL {
    #if DEBUG
    return URL(string: "http://192.168.1.49:8080")!
//    return URL(string: "https://www.sumwhere.kr")!
    #else
    return URL(string: "https://www.sumwhere.kr")!
    #endif
  }
  
  public var path: String{
    switch self { 
    case .signUp:
      return "/signup"
    case .signIn:
      return "/signin/email"
    case .tokenLogin:
      return "/restrict/token/vaild"
    case .facebook:
      return "/signin/facebook"
    case .kakao:
      return "/signin/kakao"
    case .isProfile:
      return "/restrict/existProfile"
    case .country:
      return "/country/"
    case .nicknameConfirm(let nickname):
      return "signup/nickname/\(nickname)"
    case .GetAllTrip:
      return "/restrict/trip"
    case .createProfile:
      return "/restrict/profile"
    case .searchDestination:
      return "/restrict/tripplaces"
    case .createTrip:
      return "/restrict/trip"
    case .myTrip,.deleteMyTrip:
      return "/restrict/mytrip"
    case .user:
      return "/restrict/user"
    case .anotherUser:
      return "/restrict/another_user"
    case .userWithProfile:
      return "/restrict/user_with_profile"
    case .AllTripList:
      return "/restrict/alltriplist"
    case .GetAllTripStyle:
      return "/restrict/tripstyle"
    case .GetAllInterest:
      return "/restrict/interests"
    case .GetAllCharacter:
      return "/restrict/characters"
    case .TripDestinationValidate:
      return "/restrict/trip/destination/validate"
    case .TripDateValidate:
      return "/restrict/trip/date/validate"
    case .RelationShipMatch:
      return "/restrict/match/relationship"
    case .MatchRequest:
      return "/restrict/match/request"
    case .MatchRequestReceive:
      return "/restrict/match/receive"
    case .MatchRequestSend:
      return "/restrict/match/send"
    case .MatchType:
      return "/restrict/matchType"
    case .GetChatRoom:
      return "/restrict/chat/room"
    case .IAPSuccess:
      return "/restrict/purchase/receipt"
    case .IAPList:
      return "/restrict/purchase/list"
    case .IAPInfo:
      return "/restrict/purchase/info"
    case .purchaseHistory(let pageNum):
      return "/restrict/purchase/history/\(pageNum)"
    case .event:
      return "/restrict/event"
    case .Notice:
      return "/restrict/notice"
    case .banner:
      return "/restrict/banner"
    case .SignOut:
      return "/restrict/signout"
    case .GetPush,.UpdatePush:
      return "/restrict/push"
    case .FcmUpdate:
      return "/restrict/fcmToken"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp,.createProfile,.kakao,.facebook,.createTrip,.MatchRequest,.IAPSuccess:
      return .post
    case .deleteMyTrip,.SignOut:
      return .delete
    case .UpdatePush,.FcmUpdate:
      return .put
    default:
      return .get
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var task: Task {
    switch self {
    case .signUp(let json):
      return .requestJSONEncodable(json)
    case .signIn(let email,let password):
      return .requestParameters(parameters: ["email":email,"password":password], encoding: URLEncoding.queryString)
    case .userWithProfile(let id):
      if let id = id {
        return .requestParameters(parameters: ["id":id], encoding: URLEncoding.queryString)
      }
      return .requestPlain
    case .anotherUser(let id):
      return .requestParameters(parameters: ["id":id], encoding: URLEncoding.queryString)
    case .facebook(let token),.kakao(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.httpBody)
    case let .GetAllTrip(order, sortby, skipCount):
      return .requestParameters(parameters: ["order":order,"password":sortby,"skipCount": skipCount], encoding: URLEncoding.queryString)
    case .createProfile(let data):
      return .uploadMultipart(data)
    case .searchDestination(let data):
      return .requestParameters(parameters: ["name":data], encoding: URLEncoding.queryString)
    case .createTrip(let json),.MatchRequest(let json),.UpdatePush(let json):
      return .requestJSONEncodable(json)
    case .AllTripList(let sortby, let order, let skipCount, let maxResultCount):
      return .requestParameters(parameters: ["sortby": sortby,"order":order,"skipCount":skipCount,"maxResultCount": maxResultCount], encoding: URLEncoding.queryString)
    case .TripDateValidate(let start, let end):
      return .requestParameters(parameters: ["start": start,"end":end],encoding: URLEncoding.queryString)
    case .TripDestinationValidate(let id):
      return .requestParameters(parameters: ["id": id],encoding: URLEncoding.queryString)
    case .RelationShipMatch(let tripId, let startDate, let endDate):
      return .requestParameters(parameters: ["tripid":tripId,"start":startDate,"end":endDate], encoding: URLEncoding.queryString)
    case .deleteMyTrip(let id):
      return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
    case .IAPSuccess(let receipt,let identifier):
      return .requestParameters(parameters: ["receiptdata": receipt,"identifier": identifier], encoding: URLEncoding.httpBody)
    case .IAPInfo(let productName):
      return .requestParameters(parameters: ["productName": productName], encoding: URLEncoding.queryString)
    case .FcmUpdate(let token):
      return .requestParameters(parameters: ["fcmtoken": token], encoding: URLEncoding.httpBody)
    default:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return ["X-Request-ID": randomString(15)]
  }
  
  public var authorizationType: AuthorizationType {
    switch self {
    case .signUp,.nicknameConfirm,.signIn:
      return .none
    default:
      return .bearer
    }
  }
}
