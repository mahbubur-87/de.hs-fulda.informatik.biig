//
//  NEngine.swift
//  BIIG
//
//  Created by mahbub on 4/9/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation
import CoreLocation

// TODO:
// 1. Make DTO for Navigation Engine -> (Distance DTO and Direction DTO)
// 2. Make generic methods of distance matrix that will fit for all usecases
class NEngine: RESTServiceDelegate {
    
    private let googleDirection = GoogleDirectionService()
    private let googleDistance = GoogleDistanceService()
    private var origins: [CLLocationCoordinate2D]?
    private var destinations: [CLLocationCoordinate2D]?
    
    var delegate: EngineDelegate?
    
    init() {
        
        self.delegate = nil
        self.origins = nil
        self.destinations = nil
        
        self.googleDirection.delegate = self
        self.googleDistance.delegate = self
    }
    
    func getDirection(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        self.googleDirection.get(origin: origin, destination: destination)
    }
    
    // TODO: actual name will be getDistanceMatrix that will fit for any usecases
    //    func getDistanceMatrix(origins: [CLLocationCoordinate2D], destinations: [CLLocationCoordinate2D]) {
    func getDirectionFromDistanceMatrix(origins: [CLLocationCoordinate2D], destinations: [CLLocationCoordinate2D]) {
        
        self.origins = origins
        self.destinations = destinations
        self.googleDistance.get(origins: origins, destinations: destinations)
    }
    
    func handleReceivedDirection(_ direction: GoogleDirection) {
        
        guard "OK" == direction.status else {
            
            print("No Driving Direction is found from Google Directions API.")
            print("Google Directions API Error: \(direction)")
            self.delegate?.processDidAbort(reason: "No Driving Direction is found from Google Map.")
            return
        }
        
        let steps = direction.routes.flatMap({ $0.legs.flatMap({ $0.steps }) })
        
        guard !steps.isEmpty else {
            
            print("No Driving Direction is found from Google Directions API.")
            self.delegate?.processDidAbort(reason: "No Driving Direction is found from Google Map.")
            return
        }
        
        self.delegate?.processDidComplete(then: steps)
    }
    
    func handleReceivedDistance(_ distance: GoogleDistance) {
        
        guard "OK" == distance.status else {
            
            print("No Driving Distance is found from Google Distance API.")
            print("Google Distance API Error: \(distance)")
            self.delegate?.processDidAbort(reason: "No Driving Distance is found from Google Map.")
            return
        }
        
        let elements = distance.rows.flatMap({ $0.elements })
        
        var minIndex = 0
        var minElement = elements[0]
        
        for index in 1 ..< elements.count {
            
            if minElement.distance.value > elements[index].distance.value {
                
                minElement = elements[index]
                minIndex = index
            }
        }
        
        self.getDirection(origin: self.origins![0], destination: self.destinations![minIndex])
    }
    
    func dataDidReceive(data: Any) {
        
        switch data {
            
            case let direction as GoogleDirection:
                handleReceivedDirection(direction)
            
            case let distance as GoogleDistance:
                handleReceivedDistance(distance)
            
            default:
                print("Google Maps API Error: No Data is received.")
                self.delegate?.processDidAbort(reason: "No Data is received from Google Map.")
        }
    }
    
    func dataDidFail(reason message: String) {
        
        self.delegate?.processDidAbort(reason: message)
    }
    
}
