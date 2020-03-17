//
//  TypeService.swift
//  BIIG
//
//  Created by mahbub on 4/8/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

class TypeService: RESTService {
    
    static private let networkProtocol = "https"
    static private let host = "evening-waters-97508.herokuapp.com"
    
    init() {
        
        super.init(with: TypeService.networkProtocol, host: TypeService.host)
    }
    
    override func callbackAfterCompletion(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            
            print("Response Error [TypeService.swift]: \(error!.localizedDescription)")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }
        
        guard let data = data else {
            
            print("Response Error [TypeService.swift]: No Data is Found.")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }
        
        do {
            
            var decodedData: Any? = nil
            
            switch response!.url!.path {
                
            case Regex(pattern: "^/type/([A-Z]|_)+/values$"):
                
                decodedData = try JSONDecoder().decode([TypeValue].self, from: data)
                break
                
            default:
                print("No Match.")
            }
            
            self.delegate?.dataDidReceive(data: decodedData!)
            
        } catch let jsonError {
            
            print("JSON Decode Error [TypeService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to decode JSON message from BiiG REST API.")
        }
    }
    
    func getValues(of type: String) {
        
        guard !type.isEmpty else {
            
            print("Service Error [TypeService.swift]: Type Name is invalid.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        let requestUrl = "/type/" + type + "/values"
        let url = self.generateURL(using: requestUrl)
        self.processGET(for: url)
    }
    
}
