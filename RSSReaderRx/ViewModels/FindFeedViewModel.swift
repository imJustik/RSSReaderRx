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

struct FindFeedRepresent {
    let url: String
    let title: NSAttributedString
    let contentSnippet: NSAttributedString
}

class FindFeedViewModel {
    
    
    var searchText = Variable("")
    
    let arrayFindFeeds = PublishSubject<[FindFeedRepresent]>()
    
    var findFeed: FindFeedModel? {
        didSet {
            
        }
    }
    
    
    init() {
        
        let resultFromServer = searchText.asObservable().flatMapLatest { text in
            ServerManager.shared.getRSSFindFeed(text)
        }
        .observeOn(MainScheduler.instance)
        .throttle(2, scheduler: MainScheduler.instance)
        .debug("Representer")
        
        _ = resultFromServer.subscribe(onNext: { seq in
            var findFeedRepresent = [FindFeedRepresent]()
            if !seq.isEmpty {
                seq.forEach {
                    let title = self.prepareHTMLString(string: $0.title, font: "Times New Roman", fontSize: 18)
                    let contentSnippet = self.prepareHTMLString(string: $0.contentSnippet, font: "Times New Roman", fontSize: 16)
                    let pr = FindFeedRepresent(url: $0.url, title: title, contentSnippet: contentSnippet)
                    findFeedRepresent.append(pr)
                }
                
            }
            self.arrayFindFeeds.onNext(findFeedRepresent)
            findFeedRepresent = []
        })
        
        
    }
    
    
    // т.к сервер возвращает строку в формате HTML (с тегами), необходимо сформировать NSAttributesString
    
    private func prepareHTMLString(string: String, font: String, fontSize: Int) -> NSAttributedString {
        do {
            let attString = try NSAttributedString(data: "<span style=\"font-family: \(font); font-size: \(fontSize)\">\(string)</span>".data(using: String.Encoding.unicode)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            return attString
        }
        catch {
            return NSAttributedString(string: "")
        }

        
        
    }
}
