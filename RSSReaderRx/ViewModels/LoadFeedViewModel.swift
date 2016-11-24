//
//  LoadFeedViewModel.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 23.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoadFeedViewModel {
    
    
    //var feedURL = Variable("")
    let arrayLoadFeeds = PublishSubject<[LoadFeedRepresent]>()
    
    init(URLString: String) {
        let resultFromServer = ServerManager.shared.loadFeed(URLString)
        .observeOn(MainScheduler.instance)
        .throttle(0.5, scheduler: MainScheduler.instance)
        .debug("Load feed")
        
        _ = resultFromServer.subscribe(onNext: { seq in
            var loadFeedRepresent = [LoadFeedRepresent]()
            if !seq.isEmpty {
                seq.forEach {
                    let title = $0.title.prepareHTMLString(font: "Times New Roman", fontSize: 18)
                    let contentSnippet = $0.content.prepareHTMLString(font: "Times New Roman", fontSize: 16)
                    let pr = LoadFeedRepresent(url: $0.url, title: title, content: contentSnippet)
                    loadFeedRepresent.append(pr)
                }
                
            }
            self.arrayLoadFeeds.onNext(loadFeedRepresent)
            loadFeedRepresent = []
        })
        

        
    }
    
    
}
