//
//  ViewController+Presenter.swift
//  WebServiceParsing
//
//  Created by Sanith Raj on 4/1/19.
//  Copyright © 2019 Sanith Raj. All rights reserved.
//

import Foundation
import XfinityServiceManager


class ViewControllerPresenter {
    
    var relatedTopics: [Topics] = [Topics]()
    private var topics: [Topics] = [Topics]()
    
    func search(query: String, _ handler:  (_ success: Bool) -> Void) {
        if query.count > 0 {
            relatedTopics = topics.filter { (topic) in
                return (((topic.title?.contains(query))!))
            }
        }else {
            relatedTopics = topics
        }
        handler(true)
    }
    
    func getItems(query: String,  _ handler: @escaping (_ topics: [Topics]) -> Void) {

        ServiceManager.getItems(query: query) { (json, error) in
            if let e = error {
                print("error: \(#function)", e)
                return
            }
            
            if let response = json as? [String: Any] {
                if let topics = response[ServiceResponseKeys.relatedTopics.rawValue] as? [[String: Any]] {
                    
                    if self.relatedTopics.count > 0 {
                        self.topics.removeAll()
                    }
                    
                    topics.forEach({ (item) in
                        let topic = Topics(with: item)
                        self.topics.append(topic)
                    })
                    self.relatedTopics = self.topics
                    handler(self.relatedTopics)
                }
            }
        }
    }
}
