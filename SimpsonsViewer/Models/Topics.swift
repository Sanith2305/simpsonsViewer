//
//  Topics.swift
//  WebServiceParsing
//
//  Created by Sanith Raj on 4/1/19.
//  Copyright © 2019 Sanith Raj. All rights reserved.
//

import Foundation

struct Topics {
    var title: String? = nil
    var desc: String? = nil
    var imageURL: String? = nil
    
    init(with topic: [String: Any]) {
        if let text = topic["Text"] as? String {
            let textArr = text.components(separatedBy: "-")
            if let title = textArr.first, let desc  = textArr.last {
                self.title = title
                self.desc = desc
            }
        }
        if let icon = topic["Icon"] as? [String: Any], let url = icon["URL"] as? String {
            self.imageURL = url
        }
    }
}
