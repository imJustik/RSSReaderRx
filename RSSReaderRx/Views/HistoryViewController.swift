//
//  HistoryViewController.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 26.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cacheViewModel = HistoryViewModel()
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        cacheViewModel.getHistory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
            _ = cacheViewModel.findFeedCache.asObservable().bindTo(tableView.rx.items(cellIdentifier: "HistoryCell", cellType: FindFeedCell.self)) {_, findFeed, cell in
                cell.contentSnippet.attributedText = findFeed.content.prepareHTMLString(font: "Times New Roman", fontSize: 16)
                cell.titleLable.attributedText = findFeed.title.prepareHTMLString(font: "Times New Roman", fontSize: 18)
                
                }.addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
