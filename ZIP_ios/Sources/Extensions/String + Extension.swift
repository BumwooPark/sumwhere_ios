//
//  String + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 30..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

extension String {
  func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
    let lowerCaseString = string.lowercased()
    var result: [Range<Index>] = []
    var start = startIndex
    while let range = range(of: lowerCaseString, options: options, range: start..<endIndex) {
      result.append(range)
      start = range.upperBound
    }
    return result
  }
}

/*
 "abcde"[0] === "a"
 "abcde"[0...2] === "abc"
 "abcde"[2..<4] === "cd"
 */
extension String {
  
  subscript (i: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
}


extension String {
  func addSumwhereImageURL() -> String {
    return AuthManager.imageURL + self
  }
}
