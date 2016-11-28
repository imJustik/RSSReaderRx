//
//  LoadFeedViewController.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 23.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoadFeedViewController: UIViewController {
    var loadFeedViewModel : LoadFeedViewModel?
    var stringURL = ""
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        loadFeedViewModel = LoadFeedViewModel(URLString: stringURL)
        
        if let viewModel = loadFeedViewModel {
            _ = viewModel.arrayLoadFeeds.drive(tableView.rx.items(cellIdentifier: "LoadFeedCell", cellType: LoadFeedCell.self)) {_, findFeed, cell in
                cell.FeedLabel.attributedText = findFeed.content.prepareHTMLString(font: "Times New Roman", fontSize: 16)
                cell.titleLable.attributedText = findFeed.title.prepareHTMLString(font: "Times New Roman", fontSize: 18)
                
                }.addDisposableTo(disposeBag)

        
        
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
