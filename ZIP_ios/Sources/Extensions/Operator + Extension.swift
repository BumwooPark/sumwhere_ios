//
//  Operator + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 24/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import Foundation

func + <T>(lhs: [T], rhs: T) -> [T] {
  var copy = lhs
  copy.append(rhs)
  return copy
}

