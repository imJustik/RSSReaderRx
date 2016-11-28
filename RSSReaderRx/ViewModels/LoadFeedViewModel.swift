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
    
    let arrayLoadFeeds : Driver<[LoadFeedModel]>
    
    init(URLString: String) {
        arrayLoadFeeds = ServerManager.shared.loadFeed(URLString)
        .asDriver(onErrorJustReturn: [])
    }
    
    
}
