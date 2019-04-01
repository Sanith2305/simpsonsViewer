//
//  ServiceManager.swift
//  XfinityServiceManager
//
//  Created by Sanith Raj on 4/1/19.
//  Copyright © 2019 Sanith Raj. All rights reserved.
//

import Foundation

public typealias networkHandler = (_ json: Any?, _ error: Error?) -> Void

public class ServiceManager {
    
    static let components: ServiceURLComponents = ServiceURLComponents()
    static let networkManager: NetworkManager = NetworkManager()
    
    public static func getItems(query: String, completionHandler: @escaping networkHandler ) {
        if  let url = components.urlComponents(for: query) {
            networkManager.getRequest(url: url, completionHandler: completionHandler)
        }
    }
}

class ServiceURLComponents {
    
    /// creates the url by providing the scheme, host
    ///
    /// - Parameter search: query search string
    /// - Returns: it returns the url
    func urlComponents(for search: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.duckduckgo.com"
        
        let quertyItem = URLQueryItem(name: "q", value: search)
        let formatItem = URLQueryItem(name: "format", value: "json")
        
        components.queryItems = [quertyItem,formatItem]
        return components.url
    }
}

class NetworkManager {
    func getRequest(url: URL, completionHandler: @escaping networkHandler) {
        URLSession.shared.dataTask(with:  url) { (data, response, error) in
            
            if let _ = error {
                completionHandler(nil, error)
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200, let _ = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    completionHandler(json, nil)
                }catch let error {
                    completionHandler(nil,  error)
                }
            }
        }.resume()
    }
}
