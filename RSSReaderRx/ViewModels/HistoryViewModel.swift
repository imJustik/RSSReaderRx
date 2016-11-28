//
//  HistoryViewModel.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 26.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HistoryViewModel {
    let findFeedCache: Variable<[FindFeedModel]>
    
    let rrr = Observable.just(1,2,3,4)
    
    init() {
        findFeedCache = DBManager.shared.history
    }
    
    func getHistory() {
        DBManager.shared.loadFeedFromCache()
    }
}
