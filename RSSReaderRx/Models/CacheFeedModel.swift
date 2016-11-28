//
//  CacheFeedModel.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 25.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import RealmSwift

class CacheFeedModel: Object {
    dynamic var id = 0
    dynamic var url = ""
    dynamic var title = ""
    dynamic var content = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
