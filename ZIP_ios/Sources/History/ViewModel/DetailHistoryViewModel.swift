//
//  DetailHistoryViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 21/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

protocol DetailHistoryOutputs {
}

protocol DetailHistoryInputs{
  func getTrip(id: Int)
}

protocol DetailHistoryTypes{
  var outputs: DetailHistoryOutputs {get}
  var inputs: DetailHistoryInputs {get}
}

class DetailHistoryViewModel: DetailHistoryTypes, DetailHistoryInputs, DetailHistoryOutputs {
  var outputs: DetailHistoryOutputs {return self}
  var inputs: DetailHistoryInputs {return self}
  init() {
  }
  
  
  func getTrip(id: Int) {
    
  }
}
