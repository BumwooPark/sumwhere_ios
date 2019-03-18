//
//  String + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 30..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import SwiftDate

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

extension String{
  func dateTimeKoreaConverter() -> String?{
    guard let date = self.toISODate(nil, region: Region(calendar: Calendars.gregorian, zone: Zones.asiaSeoul, locale: Locales.korean))
      else {return nil}
    
    if date.compare(.isToday){
      return "오늘"
    }else if date.isInRange(date: Date().dateByAdding(-7, .day), and: Date().inDefaultRegion()){
      let day = Date().inDefaultRegion().timeIntervalSince(date).toUnit(.day) ?? 0
      return "\(day)일 전"
    }else{
      return date.toFormat("MM월 dd일 yyyy")
    }
  }
}
