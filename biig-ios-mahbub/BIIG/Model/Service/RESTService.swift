//
//  RESTService.swift
//  BIIG
//
//  Created by mahbub on 1/18/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

class RESTService {
    
    static private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    private var networkProtocol: String
    private var host: String
    private var port: Int?
    
    var delegate: RESTServiceDelegate?
    
    init(with networkProtocol: String, host: String, port: Int? = nil) {
        
        self.networkProtocol = networkProtocol
        self.host = host
        self.port = port
        
        self.delegate = nil
    }
    
    func callbackAfterCompletion(data: Data?, response: URLResponse?, error: Error?) {}
    
    func generateURL(using path: String, query: [String : String?]? = nil) -> URL? {
        
        var components = URLComponents()
        
        components.scheme = self.networkProtocol
        components.host = self.host
        
        if let port = self.port {
            
            components.port = port
        }
        
        components.path = path
        
        if let query = query {
            
            var queryItems = [URLQueryItem]()
            
            for (name, value) in query {
                queryItems += [URLQueryItem(name: name, value: value)]
            }
            
            components.queryItems = queryItems
        }
        
        return components.url
    }
    
    func processGET(for url: URL?) {
        
        guard let url = url else {
            
            print("Service Error [RESTService.swift]: Invalid URL String.")
            self.delegate?.dataDidFail(reason: "Invalid Request.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        RESTService.urlSession
            .dataTask(with: request, completionHandler: callbackAfterCompletion)
            .resume()
    }
    
    func processPOST(for url: URL?, payload: Data) {
        
        guard let url = url else {
            
            print("Service Error [RESTService.swift]: Invalid URL String.")
            self.delegate?.dataDidFail(reason: "Invalid Request.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        
        RESTService.urlSession
            .dataTask(with: request, completionHandler: callbackAfterCompletion)
            .resume()
    }
    
}
