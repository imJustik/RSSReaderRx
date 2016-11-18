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
            _ = viewModel.data.drive(tableView.rx.items(cellIdentifier: "FindFeedCell", cellType: FindFeedCell.self)) {_, findFeed, cell in
                cell.contentSnippet.attributedText  = self.prepareHTMLText(text: findFeed.contentSnippet, font: "Times New Roman", fontSize: 16)
                cell.titleLable.attributedText = self.prepareHTMLText(text: findFeed.title, font: "Times New Roman", fontSize: 18)
                
            }

        _ = searchBar.rx.text.orEmpty.bindTo(viewModel.searchText)
        _ = searchBar.rx.cancelButtonClicked.map{""}.bindTo(viewModel.searchText)
            
            _ = searchBar.rx.textDidEndEditing.asDriver().drive {
                self.searchBar.endEditing(true)
            }
        
    }
}

    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter username"
        searchBar.text = "Путин"
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.isTranslucent = false
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        searchBar.barTintColor = UIColor.white
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    
    private func prepareHTMLText(text: String, font: String, fontSize: Int) -> NSAttributedString {
        do {
            return try NSAttributedString(data: "<span style=\"font-family: \(font); font-size: \(fontSize)\">\(text)</span>".data(using: String.Encoding.unicode)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        }
        catch {
            return NSAttributedString(string: "")
        }
    }

    


}

