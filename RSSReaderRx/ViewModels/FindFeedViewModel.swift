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
    var arrayFindFeeds : Driver<[FindFeedModel]>
    
    init() {
        arrayFindFeeds = self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest {
                ServerManager.shared.getRSSFindFeed($0)
            }.asDriver(onErrorJustReturn: ([]))
            .debug("data")
    }
}

extension Observable where Element: Hashable {
    
    func distinct() -> Observable<Element> {
        var set = Set<Element>()
        return flatMap { element -> Observable<Element> in
            objc_sync_enter(self); defer {objc_sync_exit(self)}
            if set.contains(element) {
                return Observable<Element>.empty()
            } else {
                set.insert(element)
                return Observable<Element>.just(element)
            }
        }
    }
}
