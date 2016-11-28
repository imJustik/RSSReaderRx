//
//  LoadFeedModel.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 18.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import Unbox

struct LoadFeedModel: FeedProtocol {
    var url: String
    var title: String
    var content: String
}

extension LoadFeedModel : Unboxable {
    
    init(unboxer: Unboxer) throws {
        do {
            self.url = try unboxer.unbox(key: "link")
            self.content = try unboxer.unbox(key: "content")
            self.title = try unboxer.unbox(key: "title")
        } catch {
            self.url = ""
            self.content = ""
            self.title = ""
        }
    }
}
