//
//  MatchHistoryViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 01/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

internal protocol MatchHistoryOutputs{
  var historyData: BehaviorRelay<[HistorySectionModel]> {get}
}

internal protocol MatchHistoryInputs{
  func getHistoryData()
}

internal protocol MatchHistoryTypes{
  var outputs: MatchHistoryOutputs {get}
  var inputs: MatchHistoryInputs {get}
}

class RequestHistoryViewModel: MatchHistoryTypes, MatchHistoryInputs, MatchHistoryOutputs{
  var outputs: MatchHistoryOutputs {return self}
  var inputs: MatchHistoryInputs {return self}
  var historyData = BehaviorRelay<[HistorySectionModel]>(value: [])
  let disposeBag = DisposeBag()
  init() {
  }
  
  func getHistoryData(){
    let result = AuthManager.instance.provider
      .request(.GetMatchRequestHistory)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[MatchHistoryModel]>.self)
      .map{$0.result}
      .map{$0 ?? []}
      .asObservable()
      .materialize()
      .share()

    result.elements()
      .flatMap { (models)  -> Observable<[HistorySectionModel]> in
        var modelData = [TripPlaceJoin:[MatchHistoryModel]]()
        for model in models {
          modelData[TripPlaceJoin(trip: model.trip,tripPlace: model.tripPlace), default: []].append(model)
        }
        var sectionModels = [HistorySectionModel]()
        for (k,v) in modelData{
          sectionModels.append(HistorySectionModel.HistoryTrip(trip: k, items: v))
        }
        return Observable.just(sectionModels)
      }.bind(to: historyData)
      .disposed(by: disposeBag)

    
  }
}

class ReceiveHistoryViewModel: MatchHistoryTypes, MatchHistoryInputs, MatchHistoryOutputs{
  let disposeBag = DisposeBag()
  var outputs: MatchHistoryOutputs {return self}
  var inputs: MatchHistoryInputs {return self}
  var historyData = BehaviorRelay<[HistorySectionModel]>(value: [])
  init() {
  }
  
  func getHistoryData(){
    let result = AuthManager.instance.provider
      .request(.GetMatchReceiveHistory)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[MatchHistoryModel]>.self)
      .map{$0.result}
      .map{$0 ?? []}
      .asObservable()
      .materialize()
      .share()
    
    result.elements()
      .flatMap { (models)  -> Observable<[HistorySectionModel]> in
        var modelData = [TripPlaceJoin:[MatchHistoryModel]]()
        for model in models {
          modelData[TripPlaceJoin(trip: model.trip,tripPlace: model.tripPlace), default: []].append(model)
        }
        var sectionModels = [HistorySectionModel]()
        for (k,v) in modelData{
          sectionModels.append(HistorySectionModel.HistoryTrip(trip: k, items: v))
        }
        return Observable.just(sectionModels)
      }.bind(to: historyData)
      .disposed(by: disposeBag)
  }
}



