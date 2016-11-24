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
        
        configureSearchController()
        findFeedViewModel = FindFeedViewModel()
        
        if let viewModel = findFeedViewModel {
            _ = viewModel.arrayFindFeeds.bindTo(tableView.rx.items(cellIdentifier: "FindFeedCell", cellType: FindFeedCell.self)) {_, findFeed, cell in
                cell.contentSnippet.attributedText = findFeed.content
                cell.titleLable.attributedText = findFeed.title
        
            }.addDisposableTo(disposeBag)
        
        _ = searchBar.rx.text.orEmpty.bindTo(viewModel.searchText)
        _ = searchBar.rx.cancelButtonClicked.map{""}.bindTo(viewModel.searchText)
            
    }
       _ =  tableView.rx.modelSelected(FindFeedRepresent.self).subscribe(onNext: {
            print($0)
            let _storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loadFeedVC =  _storyboard.instantiateViewController(withIdentifier: "LoadFeedVC") as! LoadFeedViewController
            loadFeedVC.stringURL = $0.url
            self.navigationController?.pushViewController(loadFeedVC, animated: true)
        })
}
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "ToLoadFeedsSegue"? :
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let loadFeedVC: LoadFeedViewController = segue.destination as! LoadFeedViewController
//                loadFeedVC.stringURL = tableView.cellForRow(at: indexPath) as
//            }
//        default:
//            break
//        }
//    }
    
    

    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter username"
        searchBar.text = "Путин"
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        //searchBar.isTranslucent = false
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

