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
}

extension ZIP: TargetType, AccessTokenAuthorizable{

  public var baseURL: URL {
    #if DEBUG
    return URL(string: "http://192.168.0.3:8080/galmal")!
    #else
    return URL(string: "https://bumwoopark.iptime.org/galmal")!
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
      return "/restrict/triptype"
    case .createTrip:
      return "/restrict/trip"
    case .myTrip,.deleteMyTrip:
      return "/restrict/mytrip"
    case .user:
      return "/restrict/user"
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
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp,.createProfile,.kakao,.facebook,.createTrip,.MatchRequest:
      return .post
    case .deleteMyTrip:
      return .delete
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
    case .facebook(let token),.kakao(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.httpBody)
    case let .GetAllTrip(order, sortby, skipCount):
      return .requestParameters(parameters: ["order":order,"password":sortby,"skipCount": skipCount], encoding: URLEncoding.queryString)
    case .createProfile(let data):
      return .uploadMultipart(data)
    case .searchDestination(let data):
      return .requestParameters(parameters: ["name":data], encoding: URLEncoding.queryString)
    case .createTrip(let json):
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
    case .MatchRequest(let json):
      return .requestJSONEncodable(json)
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
