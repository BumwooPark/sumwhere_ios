//
//  KeyChainManager.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Security

class KeyChainManager{
  class func save(key: String, data: Data) -> Bool{
    let query = [kSecClass as String : kSecClassGenericPassword as String,
                 kSecAttrAccount as String: key,
                 kSecValueData as String: data] as [String: Any]
    SecItemDelete(query as CFDictionary)
    
    let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
    return status == noErr
  }
  
  class func load(key: String) -> Data?{
    let query = [
      kSecClass as String : kSecClassGenericPassword,
      kSecAttrAccount as String : key,
      kSecReturnData as String : kCFBooleanTrue,
      kSecMatchLimit as String : kSecMatchLimitOne] as [String: Any]
    
    var dataTypeRef: AnyObject?
    let status = withUnsafeMutablePointer(to: &dataTypeRef) {  SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))}
    if status == errSecSuccess{
      if let data = dataTypeRef as! Data?{
        return data
      }
    }
    return nil
  }
  
  class func delete(key: String) -> Bool{
    let query = [
      kSecClass as String : kSecClassGenericPassword,
      kSecAttrAccount as String : key] as [String: Any]
    let status: OSStatus = SecItemDelete(query as CFDictionary)
    return status == noErr
  }
  
  class func clear() -> Bool{
    let query = [kSecClass as String : kSecClassGenericPassword]
    let status: OSStatus = SecItemDelete(query as CFDictionary)
    return status == noErr
  }
}



//class test{
//  init() {
//    let id = "sample"
//    let password = "1234"

//    if let idData = id.data(using: String.Encoding.utf8),let passwordData = password.data(using: String.Encoding.utf8){
//      print(KeyChainManager.save(key: "id", data: idData))
//      print(KeyChainManager.save(key: "password", data: passwordData)
//    }
//
//    if let idData = KeyChainManager.load(key: "id"), let passwordData = KeyChainManager.load(key: "password"){
//      if let id = String(data: idData, encoding: String.Encoding.utf8), let password = String(data: passwordData, encoding: String.Encoding.utf8){
//
//      }
//    }
//  }
//}



