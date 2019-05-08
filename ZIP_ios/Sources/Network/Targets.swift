//
//  Targets.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Moya

public enum ZIP{
  //main
  case mainList
  //Signin & UP
  case signUp(model: Encodable)
  case signIn(email: String, password: String)
  case verifyToken(token: String)
  
  // Main
  case background
  
  //Place
  case placeSearch(tag: String)
  
  case tokenLogin
  case facebook(access_token: String)
  case kakao(access_token: String)
  case nicknameConfirm(nickname: String)
  case isProfile
  case country
  case GetAllTrip
  case createProfile(data: [MultipartFormData])
  case user
  case anotherUser(id: String)
  case userWithProfile(id: String?)
  case createTrip(model: Encodable)
  case deleteTrip(tripId: Int)
  case searchDestination(data: String)
  case AllTripList(sortby: String, order: String, skipCount: Int, maxResultCount: Int)
  case GetAllTripStyle
  case GetAllInterest
  case GetAllCharacter
  case MatchRequest(model: Encodable)
  case MatchRequestReceive
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
  
  // Push
  case GetPushHistory
  case GetPush
  case UpdatePush(model: Encodable)
  
  case FcmUpdate(token: String)
  case GetMatchList(tripId: Int)
  case NewMatchList(tripId: Int)
  case UpdateTrip(tripId: Int, data: [String: String])
  case PossibleMatchCount
  case Countrys
  case tripPlaces(countryId: Int)
  case TotalMatchCount
  //Match
  case GetTripStyles(ids: String)
  case GetMatchStatus(id: String)
  case GetMatchRequestHistory
  case GetMatchReceiveHistory
  case MatchAccept(historyID: Int)
  case MatchRefuse(historyID: Int)
}

extension ZIP: TargetType, AccessTokenAuthorizable{

  public var baseURL: URL {
    #if DEBUG
    return URL(string: "http://localhost:8000")!
//    return URL(string: "https://www.sumwhere.kr/v1")!
    #else
    return URL(string: "https://www.sumwhere.kr/v1")!
    #endif
  }
  
  public var path: String{
    switch self {
    case .mainList:
      return "/restrict/main/list"
    case .signUp:
      return "/rest-auth/registration/"
    case .signIn:
      return "/rest-auth/login/"
    case .verifyToken:
      return "/api-token-verify/"
      
    case .background:
      return "/main/background/"
    case .placeSearch:
      return "/place"
    case .tokenLogin:
      return "/restrict/token/vaild"
    case .facebook:
      return "/rest-auth/facebook"
    case .kakao:
      return "/rest-auth/kakao"
    case .isProfile:
      return "/restrict/existProfile"
    case .country:
      return "/country/"
    case .nicknameConfirm(let nickname):
      return "signup/nickname/\(nickname)"
    case .GetAllTrip:
      return "/restrict/trip"
    case .Countrys:
      return "/restrict/trip/country"
    case .tripPlaces(let countryID):
      return "/restrict/trip/place/\(countryID)"
    case .createProfile:
      return "/restrict/profile"
    case .searchDestination:
      return "/restrict/tripplaces"
    case .createTrip,.deleteTrip:
      return "/restrict/trip"
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
    case .MatchRequest:
      return "/restrict/match/request"
    case .MatchRequestReceive:
      return "/restrict/match/receive"
    case .MatchType:
      return "/restrict/match/type"
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
    case .GetPushHistory:
      return "/restrict/push/history"
    case .FcmUpdate:
      return "/restrict/fcmToken"
    case .GetMatchList:
      return "/restrict/match/list"
    case .NewMatchList:
      return "/restrict/match/new"
    case .UpdateTrip(let id, _):
      return "/restrict/trip/\(id)"
    case .TotalMatchCount:
      return "/restrict/match/totalcount"
    case .PossibleMatchCount:
      return "/restrict/match/check"
    case .GetTripStyles:
      return "/restrict/trip/style"
    case .GetMatchStatus:
      return "/restrict/match/status"
    case .GetMatchRequestHistory:
      return "/restrict/match/history/request"
    case .GetMatchReceiveHistory:
      return "/restrict/match/history/receive"
    case .MatchAccept:
      return "/restrict/match/accept"
    case .MatchRefuse:
      return "/restrict/match/refuse"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp,.signIn,.createProfile,.kakao,.facebook,.createTrip,.MatchRequest,.IAPSuccess,.verifyToken:
      return .post
    case .deleteTrip,.SignOut:
      return .delete
    case .UpdatePush,.FcmUpdate:
      return .put
    case .UpdateTrip,.MatchRefuse,.MatchAccept:
      return .patch
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
      return .requestParameters(parameters: ["email":email,"password":password], encoding: JSONEncoding.default)
    case .userWithProfile(let id):
      if let id = id {
        return .requestParameters(parameters: ["id":id], encoding: URLEncoding.queryString)
      }
      return .requestPlain
    case .verifyToken(let token):
      return .requestParameters(parameters: ["token":token], encoding: JSONEncoding.default)
      
    case .placeSearch(let tag):
      return .requestParameters(parameters: ["tag":tag], encoding: URLEncoding.queryString)
      
      
    case .anotherUser(let id):
      return .requestParameters(parameters: ["id":id], encoding: URLEncoding.queryString)
    case .facebook(let token),.kakao(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: JSONEncoding.default)
    case .createProfile(let data):
      return .uploadMultipart(data)
    case .searchDestination(let data):
      return .requestParameters(parameters: ["name":data], encoding: URLEncoding.queryString)
    case .createTrip(let json),.MatchRequest(let json),.UpdatePush(let json):
      return .requestJSONEncodable(json)
    case .AllTripList(let sortby, let order, let skipCount, let maxResultCount):
      return .requestParameters(parameters: ["sortby": sortby,"order":order,"skipCount":skipCount,"maxResultCount": maxResultCount], encoding: URLEncoding.queryString)
    case .deleteTrip(let id):
      return .requestParameters(parameters: ["tripId": id], encoding: URLEncoding.queryString)
    case .IAPSuccess(let receipt,let identifier):
      return .requestParameters(parameters: ["receiptdata": receipt,"identifier": identifier], encoding: URLEncoding.httpBody)
    case .IAPInfo(let productName):
      return .requestParameters(parameters: ["productName": productName], encoding: URLEncoding.queryString)
    case .FcmUpdate(let token):
      return .requestParameters(parameters: ["fcmtoken": token], encoding: URLEncoding.httpBody)
    case .GetMatchList(let id):
      return .requestParameters(parameters: ["tripId": id], encoding: URLEncoding.queryString)
    case .UpdateTrip( _, let data):
      return .requestParameters(parameters: data, encoding: URLEncoding.httpBody)
    case .GetTripStyles(let ids):
      return .requestParameters(parameters: ["numbers":ids], encoding: URLEncoding.queryString)
    case .GetMatchStatus(let id):
      return .requestParameters(parameters: ["id":id], encoding: URLEncoding.queryString)
    case .MatchAccept(let id),.MatchRefuse(let id):
      return .requestParameters(parameters: ["historyID": id], encoding: URLEncoding.queryString)
      
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
