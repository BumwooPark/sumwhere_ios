//
//  ChatListViewController.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//


import RxSwift
import RxCocoa
import RxDataSources
import MGSwipeTableCell
import XMPPFramework

class ChatListViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let viewModel = ChatListViewModel()
  var xmppController: XMPPController!
  private let dataSources = RxTableViewSectionedReloadDataSource<ChatListSectionModel>(configureCell: {ds,tv,idx,item in
    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: ChatListCell.self), for: idx) as! ChatListCell
    cell.rightButtons = [MGSwipeButton(title: "나가기", backgroundColor: .red)]
    return cell
  })
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 95
    tableView.backgroundColor = .white
    tableView.register(ChatListCell.self, forCellReuseIdentifier: String(describing: ChatListCell.self))
    tableView.separatorStyle = .none
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view = tableView
    
    do {
      xmppController = try XMPPController(hostName: "example.com", userJIDString: "test2@example.com", password: "1q2w3e4r")
      xmppController.connect()
      xmppController.joinRoom()
      
    }catch let error {
      log.error(error)
    }

    viewModel.datas
      .asDriver()
      .drive(tableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    viewModel.datas
      .map{$0.count}
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return { value in
          if value == 0 {
            weakSelf.collectionViewEmptyView()
          }else {
            weakSelf.tableView.backgroundView = nil
          }
        }
      }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(ChatListModel.self)
      .subscribeNext(weak: self) { (weakSelf) -> (ChatListModel) -> Void in
        return {model in
          log.info(model)
//          weakSelf.navigationController?.pushViewController(ChatRoomViewController(roomID: model.chatRoom.id, userID: model.chatMember.userId), animated: true)
        }
      }.disposed(by: disposeBag)
  }
  
  private func collectionViewEmptyView(){
    tableView.backgroundView = EmptyChatView(frame: CGRect(origin: .zero, size: tableView.bounds.size))
  }
}



