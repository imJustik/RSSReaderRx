//
//  ViewController.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 15.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var findFeedViewModel : FindFeedViewModel?
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar : UISearchBar {return searchController.searchBar }
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        configureSearchController()
        findFeedViewModel = FindFeedViewModel()
        
        if let viewModel = findFeedViewModel {
            _ = viewModel.data.drive(tableView.rx.items(cellIdentifier: "Cell", cellType: FindFeedCell.self)) {_, findFeed, cell in
                cell.contentSnippet.text = findFeed.contentSnippet
                cell.titleLable.text = findFeed.title
                
            }

        
        _ = searchBar.rx.text.orEmpty.bindTo(viewModel.searchText)
        _ = searchBar.rx.cancelButtonClicked.map{""}.bindTo(viewModel.searchText)
        
    }
}

    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "imj"
        searchBar.placeholder = "Enter username"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

