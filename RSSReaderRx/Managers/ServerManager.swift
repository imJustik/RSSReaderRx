//
//  ServerManager.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 16.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Unbox
private let _singletonInstance = ServerManager()


class ServerManager {
    private let basicURL = "https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q="
    private let loadFeedURL = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q="
    class var shared: ServerManager {
        return _singletonInstance
    }
    
    
    func getRSSFindFeed(_ title: String) -> Observable<[FindFeedModel]> {
        guard !title.isEmpty, let url = URL(string:basicURL+title.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
            else {
                return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
            .catchErrorJustReturn(Observable.just([]))
            .map {
                var findFeeds = [FindFeedModel]()
                if let dict = $0 as? UnboxableDictionary {
                     findFeeds = try unbox(dictionary: dict, atKeyPath: "responseData.entries")
                }
                return findFeeds
        }
    }
    
    func loadFeed(_ URLString: String) -> Observable<[LoadFeedModel]> {
        guard !URLString.isEmpty, let URL = URL(string: loadFeedURL + URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: URL)
                .catchErrorJustReturn(Observable.just([]))
              // .debug("LOOOADING")
                    .map {
                      //  print($0)
                        var loadFeeds = [LoadFeedModel]()
                        if let dict = $0 as? UnboxableDictionary {
                           // print(dict)
                            loadFeeds = try unbox(dictionary: dict, atKeyPath: "responseData.feed.entries")
                        }
                        return loadFeeds
        }
    }
}
