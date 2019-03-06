//
//  MatchHistorySectionModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 01/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxDataSources

enum HistorySectionModel{
  case HistoryTrip(trip: Trip, items: [MatchHistoryModel])
}

extension HistorySectionModel: SectionModelType{
  typealias Item = MatchHistoryModel
  
  var items: [MatchHistoryModel] {
    switch  self {
    case .HistoryTrip(trip: _ ,items: let items):
      return items.map {$0}
    }
  }
  
  init(original: HistorySectionModel, items: [HistorySectionModel.Item]) {
    switch original{
    case .HistoryTrip(let trip,_):
      self = .HistoryTrip(trip: trip, items: items)
    }
  }
}

extension HistorySectionModel{
  var trip: Trip{
    switch self {
    case .HistoryTrip(trip: let trip, items: _):
      return trip
    }
  }
}
