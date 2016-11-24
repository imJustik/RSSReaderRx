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
    
    let arrayFindFeeds = PublishSubject<[FindFeedRepresent]>()
    

    
    init() {
        
        let resultFromServer = searchText.asObservable().flatMapLatest { text in
            ServerManager.shared.getRSSFindFeed(text)
        }
        .observeOn(MainScheduler.instance)
        .throttle(1, scheduler: MainScheduler.instance)
        .catchErrorJustReturn([])
        _ = resultFromServer.subscribe(onNext: { seq in
            var findFeedRepresent = [FindFeedRepresent]()
            if !seq.isEmpty {
                seq.forEach {
                    let title = $0.title.prepareHTMLString(font: "Times New Roman", fontSize: 18)
                    let contentSnippet = $0.content.prepareHTMLString(font: "Times New Roman", fontSize: 16)
                    let pr = FindFeedRepresent(url: $0.url, title: title, content: contentSnippet)
                    findFeedRepresent.append(pr)
                }
                
            }
            self.arrayFindFeeds.onNext(findFeedRepresent)
            findFeedRepresent = []
        })
        
        
    }
    
    
    // т.к сервер возвращает строку в формате HTML (с тегами), необходимо сформировать NSAttributesString

    
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
