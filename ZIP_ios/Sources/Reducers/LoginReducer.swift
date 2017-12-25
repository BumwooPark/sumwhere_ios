//
//  LoginReducer.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import ReSwift

func loginReducer(action: Action, state: AppState?) -> AppState {
  // if no state has been provided, create the default state
  var state = state ?? AppState(accessToken: "", refreshToken: "", islogin: false)
  
  switch action{
  case _ as loginAction:
    state.accessToken = "1"
  default:
    break
  }
  return state
}


