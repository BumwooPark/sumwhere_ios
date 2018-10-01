//
//  InitUtil.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
  block(value)
  return value
}
