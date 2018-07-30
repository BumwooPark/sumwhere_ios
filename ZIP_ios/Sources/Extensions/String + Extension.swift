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
