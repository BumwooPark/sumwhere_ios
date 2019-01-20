//
//  NoticeModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import SwiftDate
import IGListKit

class NoticeSectionModel: ListDiffable{
  func diffIdentifier() -> NSObjectProtocol {
    return data.id as NSNumber
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? NoticeSectionModel else {return false}
    return self.data.id == object.data.id
  }
  
  var isOpen = false
  let data: NoticeModel
  
  init(data: NoticeModel) {
    self.data = data
  }
}

struct NoticeModel: Codable{
  let id: Int
  let title: String
  let text: String
  let createAt: Date
  let updateAt: Date
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case text
    case createAt = "create_at"
    case updateAt = "update_at"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    text = try container.decode(String.self, forKey: .text)
    createAt = try container.decode(String.self, forKey: .createAt).toISODate()?.date ?? Date()
    updateAt = try container.decode(String.self, forKey: .updateAt).toISODate()?.date ?? Date()
  }
  
}

//
//"id": 1,
//"title": "갈래말래가 오픈했습니다",
//"text": "안녕하세요 썸웨어입니다.\n드디어 1월30일 오늘 썸웨어가\n여러분께 정식으로 인사드리게되었어요.\n항상 더 나은 서비스로 여러분들께 보답할게요!\n많은 사랑 부탁드립니다.\n당신의 여행엔 언제나 썸웨어!",
//"create_at": "2019-01-30T06:07:45Z",
//"update_at": "2019-01-30T06:07:52Z"
