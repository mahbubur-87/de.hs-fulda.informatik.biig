//
//  GoogleDirectionService.swift
//  BIIG
//
//  Created by mahbub on 4/9/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation
import CoreLocation

class GoogleDirectionService: RESTService {
    
    static private let networkProtocol = "https"
    static private let host = "maps.googleapis.com"
    
    init() {
        
        super.init(with: GoogleDirectionService.networkProtocol, host: GoogleDirectionService.host)
    }
    
    override func callbackAfterCompletion(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            
            print("Response Error [GoogleDirectionService.swift]: \(error!.localizedDescription)")
            self.delegate?.dataDidFail(reason: "Invalid Response from Google Map API.")
            return
        }
        
        guard let data = data else {
            
            print("Response Error [GoogleDirectionService.swift]: No Data is Found.")
            self.delegate?.dataDidFail(reason: "Invalid Response from Google Map API.")
            return
        }
        
        do {
            
            let googleDirection = try JSONDecoder().decode(GoogleDirection.self, from: data)
            self.delegate?.dataDidReceive(data: googleDirection)
            
        } catch let jsonError {
            
            print("JSON Error [GoogleDirectionService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to decode JSON message from Google Map API.")
        }
    }
    
    func get(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        var query = [String : String?]()
        
        query["origin"] = "\(origin.latitude),\(origin.longitude)"
        query["destination"] = "\(destination.latitude),\(destination.longitude)"
        query["key"] = "AIzaSyBuAEEsoOT1Pgy2rcvjwM9veaao85Yio5A"
        
        let requestUrl = "/maps/api/directions/json"
        let url = self.generateURL(using: requestUrl, query: query)
        
        self.processGET(for: url)
    }
    
}
