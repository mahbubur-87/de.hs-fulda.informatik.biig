//
//  ListingAgentService.swift
//  BIIG
//
//  Created by mahbub on 4/8/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

class ListingAgentService: RESTService {
    
    static private let networkProtocol = "https"
    static private let host = "evening-waters-97508.herokuapp.com"
    
    init() {
        
        super.init(with: ListingAgentService.networkProtocol, host: ListingAgentService.host)
    }
    
    override func callbackAfterCompletion(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            
            print("Response Error [ListingAgentService.swift]: \(error!.localizedDescription)")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }
        
        guard let data = data else {
            
            print("Response Error [ListingAgentService.swift]: No Data is Found.")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }
        
        do {
            
            var decodedData: Any? = nil
            
            switch response!.url!.path {
                
                case Regex(pattern: "^/listing-agent/\\d+/properties$"):
                    
                    decodedData = try JSONDecoder().decode([Property].self, from: data)
                    break
                
                default:
                    print("No Match.")
            }
            
            self.delegate?.dataDidReceive(data: decodedData!)
            
        } catch let jsonError {
            
            print("JSON Decode Error [ListingAgentService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to decode JSON message from BiiG REST API.")
        }
    }
    
    func getProperties(of id: Int) {
        
        guard id > 0 else {
            
            print("Service Error [ListingAgentService.swift]: Listing Agent ID is invalid.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        let requestUrl = "/listing-agent/\(id)/properties"
        let url = self.generateURL(using: requestUrl)
        self.processGET(for: url)
    }
    
}
