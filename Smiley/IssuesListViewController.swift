//
//  IssuesListViewController.swift
//  Smiley
//
//  Created by Lin He on 9/22/16.
//  Copyright © 2016 heroxtech. All rights reserved.
//

import Foundation

import Moya
import UIKit
import RxCocoa
import RxSwift
import Argo

class IssueListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  let disposeBag = DisposeBag()
  let provider = RxMoyaProvider<GitHub>()
  var issueTrackerModel: IssueTrackerModel!
  
  var latestRepositoryName: Observable<String> {
    return searchBar
      .rx.text
      .throttle(3, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { $0.characters.count > 0 }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
  }
  
  func setupRx() {
    
    // Now we will setup our model
    issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
    
    // And bind issues to table view
    // Here is where the magic happens, with only one binding
    // we have filled up about 3 table view data source methods
    issueTrackerModel
      .trackIssues()
      .bindTo(tableView.rx.items(cellIdentifier: "issueCell", cellType: UITableViewCell.self)) { (row, issue: Issue, cell) in
        print(issue)
        cell.textLabel?.text = issue.title
      }
      .addDisposableTo(disposeBag)
    
    // Here we tell table view that if user clicks on a cell,
    // and the keyboard is still visible, hide it
    tableView
      .rx.itemSelected
      .subscribeNext { indexPath in
        if self.searchBar.isFirstResponder == true {
          self.view.endEditing(true)
        }
      }
      .addDisposableTo(disposeBag)
  }
}
