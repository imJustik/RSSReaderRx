//
//  FindFeedModel.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 16.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import Unbox

struct FindFeedModel: FeedProtocol {
    var url: String
    var title: String
    var content: String
    
}

extension FindFeedModel: Unboxable {
    init(unboxer: Unboxer) throws {
        do {
            self.title = try unboxer.unbox(key: "title")
            self.content = try unboxer.unbox(key: "contentSnippet")
            self.url = try unboxer.unbox(key: "url")
            
        } catch {
            self.url = ""
            self.title = ""
            self.content = ""
        }
    }
}
