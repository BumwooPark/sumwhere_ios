//
//  TripStyleModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

struct TripStyle: Codable{
  let id: Int
  let type: String
  let name: String
  let imageUrl: String
}

public class SelectTripStyleModel {
  public enum TripType{
    case type(name: String,select: UIImage,selected: UIImage)
  }
  
  let title: String
  let subTitle: String
  let datas: [TripType]
  var selectedData: [TripType]
  var isSelected = false
  init(title: String, subTitle: String, datas: [TripType]) {
    self.title = title
    self.subTitle = subTitle
    self.datas = datas
    self.selectedData = []
  }
}

public func ==(lhs: SelectTripStyleModel.TripType, rhs: SelectTripStyleModel.TripType) -> Bool {
  switch (lhs, rhs) {
  case let (.type(name,_,_), .type(name2,_,_)):
    return name == name2
  }
}

public func ==(lhs: String, rhs: SelectTripStyleModel.TripType) -> Bool {
  if case let .type(name,_,_) = rhs {
    return name == lhs
  }
  return false
}


