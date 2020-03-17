//
//  PropertyService.swift
//  BIIG
//
//  Created by mahbub on 1/18/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

class PropertyService: RESTService {
    
    static private let networkProtocol = "https"
    static private let host = "evening-waters-97508.herokuapp.com"
    
    var imageIndex: IndexPath?
    
    init() {
        
        self.imageIndex = nil
        super.init(with: PropertyService.networkProtocol, host: PropertyService.host)
    }
    
    override func callbackAfterCompletion(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            
            print("Response Error [PropertyService.swift]: \(error!.localizedDescription)")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }
        
        guard let data = data else {
            
            print("Response Error [PropertyService.swift]: No Data is Found.")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }

        if self.imageIndex != nil {
            
            self.delegate?.dataDidReceive(data: (index: self.imageIndex, data: data))
            return
        }
        
        do {
            
            var decodedData: Any? = nil
            
            switch response!.url!.path {
            
                case "/property/search":
                
                    decodedData = try JSONDecoder().decode([Property].self, from: data)
                    break
                
                case Regex(pattern: "^/property/\\d+$"):
                    
                    decodedData = try JSONDecoder().decode(Property.self, from: data)
                    break
                
                case "/property":
                    
                    decodedData = try JSONDecoder().decode(Property.self, from: data)
                    break
                
                default:
                    print("No Match.")
            }
            
            self.delegate?.dataDidReceive(data: decodedData!)
            
        } catch let jsonError {
            
            print("JSON Decode Error [PropertyService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to decode JSON message from BiiG REST API.")
        }
    }
    
    func get(by key: String) {
        
        guard !key.isEmpty else {
            
            print("Service Error [PropertyService.swift]: Property list is Empty.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        var query = [String : String?]()
        
        query["key"] = key
        query["sort"] = "Newest First"
        
        let requestUrl = "/property/search"
        let url = self.generateURL(using: requestUrl, query: query)
        self.processGET(for: url)
    }
    
    func getImage(name: String, index: IndexPath) {
        
        guard !name.isEmpty else {
            
            print("Service Error [PropertyService.swift]: Property Image not found.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        self.imageIndex = index
        
        let requestUrl = "/" + name
        let url = self.generateURL(using: requestUrl)
        self.processGET(for: url)
    }
    
    func getDetails(of id: Int) {
        
        guard id > 0 else {
            
            print("Service Error [PropertyService.swift]: Property ID is invalid.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        let requestUrl = "/property/\(id)"
        let url = self.generateURL(using: requestUrl)
        self.processGET(for: url)
    }
    
    func add(_ property: PropertyDTO) {
        
        guard property.employeeId > 0 else {
            
            print("Service Error [PropertyService.swift]: Listing Agent ID is invalid for this Property.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        let requestUrl = "/property"
        let url = self.generateURL(using: requestUrl)
        
        do {
            
            let data = try JSONEncoder().encode(property)
            self.processPOST(for: url, payload: data)
        
        } catch let jsonError {
            
            print("JSON Encode Error [PropertyService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to encode JSON message for BiiG REST API.")
        }
    }
    
}
