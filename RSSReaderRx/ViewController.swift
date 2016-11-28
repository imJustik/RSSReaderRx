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
    
    let disposeBag = DisposeBag()
    var findFeedViewModel : FindFeedViewModel?
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar : UISearchBar {return searchController.searchBar }
    
   
    override func viewDidLoad() {
         super.viewDidLoad()
        
        self.title = "RSS Reader"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        
        
        configureSearchController()
        findFeedViewModel = FindFeedViewModel()
        
        if let viewModel = findFeedViewModel {
            _ = viewModel.arrayFindFeeds.drive(tableView.rx.items(cellIdentifier: "FindFeedCell", cellType: FindFeedCell.self)) {_, findFeed, cell in
                    cell.contentSnippet.attributedText = findFeed.content.prepareHTMLString(font: "Times New Roman", fontSize: 16)
                    cell.titleLable.attributedText = findFeed.title.prepareHTMLString(font: "Times New Roman", fontSize: 18)
        
            }.addDisposableTo(disposeBag)
        _ = searchBar.rx.text.orEmpty.bindTo(viewModel.searchText)
        _ = searchBar.rx.cancelButtonClicked.map{""}.bindTo(viewModel.searchText)
            
    }
        
       _ =  tableView.rx.modelSelected(FindFeedModel.self).subscribe(onNext: {
            DBManager.shared.cache.onNext($0)
            let _storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loadFeedVC =  _storyboard.instantiateViewController(withIdentifier: "LoadFeedVC") as! LoadFeedViewController
            loadFeedVC.stringURL = $0.url
            self.navigationController?.pushViewController(loadFeedVC, animated: true)
        })
}
    

    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter username"
        searchBar.text = "Путин"
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        searchBar.barTintColor = UIColor.white
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    

}

extension String {
    func prepareHTMLString(font: String, fontSize: Int) -> NSAttributedString {
        do {
            let attString = try NSAttributedString(data: "<span style=\"font-family: \(font); font-size: \(fontSize)\">\(self)</span>".data(using: String.Encoding.unicode)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            return attString
        }
        catch {
            return NSAttributedString(string: "")
        }
        
    }
}

