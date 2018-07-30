//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import expanding_collection
import RxSwift
import RxCocoa

struct MatchType{
  let detail: String
  let title: String
  let key: Int
}


class MatchDetailTableViewController: ExpandingTableViewController {
  
  fileprivate var scrollOffsetY: CGFloat = 0
  let disposeBag = DisposeBag()
  
  let sampleData = [MatchType(detail: "하루에 4명 무료 매칭", title: "기본매칭", key: 0),
                    MatchType(detail: "내 마음대로 찾는 맞춤 매칭", title: "맞춤 매칭", key: 20),
                    MatchType(detail: "혼자가면 지루하니까", title: "말동무 매칭", key: 30),
                    MatchType(detail: "같은 여행지 동행 매칭", title: "여행지 매칭", key: 15),
                    MatchType(detail: "Fever Time", title: "Fever", key: 20)]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    }
    headerHeight = 222
    tableView.rowHeight = 111
    tableView.register(MatchCell.self, forCellReuseIdentifier: String(describing: MatchCell.self))
  }
}


// MARK: Actions

extension MatchDetailTableViewController {
  
  @IBAction func backButtonHandler(_: AnyObject) {
    // buttonAnimation
    popTransitionAnimation()
  }
}

// MARK: UIScrollViewDelegate

extension MatchDetailTableViewController {
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MatchCell.self), for: indexPath) as! MatchCell
    cell.item = sampleData[indexPath.item]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sampleData.count
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
      popTransitionAnimation()
    }
    scrollOffsetY = scrollView.contentOffset.y
  }
}
