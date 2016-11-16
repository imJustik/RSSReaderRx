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

enum MyError:Error {
    case error
}
class ServerManager {
    private let basicURL = "https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q="
    class var shared: ServerManager {
        return _singletonInstance
    }
    
    
    func getRSSFindFeed(_ title: String) -> Observable<[FindFeedModel]> {
        guard !title.isEmpty, let url = URL(string:basicURL+title.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
            else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .debug("JSON")
            .catchErrorJustReturn(Observable.just([]))
            .map {
                var findFeeds = [FindFeedModel]()
                if let dict = $0 as? UnboxableDictionary {
                     findFeeds = try unbox(dictionary: dict, atKeyPath: "responseData.entries")
                    
                }
                return findFeeds
        }
    }
}
