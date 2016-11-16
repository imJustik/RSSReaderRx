//
//  FindFeedModel.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 16.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import Unbox

struct FindFeedModel {
    var url: String
    var title: NSAttributedString
    var contentSnippet: NSAttributedString
    
}

extension FindFeedModel: Unboxable {
    init(unboxer: Unboxer) throws {
        var myAttribute: NSDictionary? = [NSFontAttributeName: UIFont.systemFont(ofSize: 20)]
        do {
            let title:String = try unboxer.unbox(key: "title")
            let contenSnippet:String = try unboxer.unbox(key: "contentSnippet")
            self.url = try unboxer.unbox(key: "url")
            
            self.title = try NSAttributedString(data: "<span style=\"font-family: Times New Roman; font-size: 18\">\(title)</span>".data(using: String.Encoding.unicode)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: &myAttribute)
            

        
            self.contentSnippet = try NSAttributedString(data: "<span style=\"font-family: Times New Roman; font-size: 16\">\(contenSnippet)</span>".data(using: String.Encoding.unicode)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: UIFont.systemFont(ofSize: 20)], documentAttributes: nil)
            
        } catch {
            self.url = ""
            self.title = NSAttributedString(string: "")
            self.contentSnippet = NSAttributedString(string: "")
        }
    }
}
