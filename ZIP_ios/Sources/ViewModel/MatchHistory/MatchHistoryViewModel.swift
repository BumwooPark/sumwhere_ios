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
//  var historyData: BehaviorRelay<>
}

internal protocol MatchHistoryInputs{
  
}

internal protocol MatchHistoryTypes{
  var outputs: MatchHistoryOutputs {get}
  var inputs: MatchHistoryInputs {get}
}

class RequestHistoryViewModel: MatchHistoryTypes, MatchHistoryInputs, MatchHistoryOutputs{
  var outputs: MatchHistoryOutputs {return self}
  var inputs: MatchHistoryInputs {return self}
  
  init() {
  }
}

class ReceiveHistoryViewModel: MatchHistoryTypes, MatchHistoryInputs, MatchHistoryOutputs{
  var outputs: MatchHistoryOutputs {return self}
  var inputs: MatchHistoryInputs {return self}
  init() {
  }
}



