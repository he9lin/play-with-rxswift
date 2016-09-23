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
  
  var latestRepositoryName: Observable<String> {
    return searchBar
      .rx.text
      .throttle(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
  }
  
  func setupRx() {
    searchBar
      .rx.text // Observable property thanks to RxCocoa
      .throttle(2, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
      .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
      .filter { $0.characters.count > 0 } // If the new value is really new, filter for non-empty query.
      .subscribeNext { [unowned self] (query) in // Here we subscribe to every new value, that is not empty (thanks to filter above).
        self.findShit(name: query)
      }
      .addDisposableTo(disposeBag) // Don't forget to add this to disposeBag to avoid retain cycle.
  }
  
  func findShit(name: String) {
    self.provider
      .request(GitHub.Repo(fullName: name))
      .mapObject(type: Repository.self)
      .observeOn(MainScheduler.instance)
      .subscribeNext { repository in
        print(repository)
      }.addDisposableTo(disposeBag)
  }
}
