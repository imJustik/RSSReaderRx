//
//  FeedProtocol.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 18.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

protocol FeedProtocol {
    var url: String { get set}
    var title: String {get set}
    var content: String {get set}
}
