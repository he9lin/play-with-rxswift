//
//  CitySearchViewController.swift
//  Smiley
//
//  Created by Lin He on 9/21/16.
//  Copyright © 2016 heroxtech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CitySearchController: UIViewController {
  var shownCities = [String]() // Data source for UITableView
  let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // Our mocked API data source
  let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated (protect against retain cycle)
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    tableView.dataSource = self
    
    searchBar
      .rx.text // Observable property thanks to RxCocoa
      .throttle(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
      .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
      .filter { $0.characters.count > 0 } // If the new value is really new, filter for non-empty query.
      .subscribeNext { [unowned self] (query) in // Here we subscribe to every new value, that is not empty (thanks to filter above).
        self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
        self.tableView.reloadData() // And reload table view data.
      }
      .addDisposableTo(disposeBag) // Don't forget to add this to disposeBag to avoid retain cycle.
  }
}

// MARK: - UITableViewDataSource
/// Here we have standard data source extension for ViewController
extension CitySearchController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shownCities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "citySearchCell", for: indexPath)
    cell.textLabel?.text = shownCities[indexPath.row]
    
    return cell
  }

}
