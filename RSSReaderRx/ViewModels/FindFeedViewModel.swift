//
//  FindFeedViewModel.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 16.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FindFeedViewModel {
    
    var searchText = Variable("")
    
    let data: Driver<[FindFeedModel]>
    
    init() {
        data = self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest {
                ServerManager.shared.getRSSFindFeed($0)
            }
            .asDriver(onErrorJustReturn: ([]))
             .debug("FindFeedViewModel")
        
    }
    
    /*try NSAttributedString(data: "<span style=\"font-family: Times New Roman; font-size: 18\">\(title)</span>".data(using: String.Encoding.unicode)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: &myAttribute)*/

}
