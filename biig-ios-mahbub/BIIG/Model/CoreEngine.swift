//
//  CoreEngine.swift
//  BIIG
//
//  Created by mahbub on 3/21/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

class CoreEngine: RESTServiceDelegate {
    
    let property = PropertyService()
    let listingAgent = ListingAgentService()
    let type = TypeService()
    let user = UserService()
    
    var delegate: EngineDelegate?
    
    init() {
        
        self.delegate = nil
        
        self.property.delegate = self
        self.listingAgent.delegate = self
        self.type.delegate = self
        self.user.delegate = self
    }
    
    func findProperties(by key: String) {
        
        self.property.get(by: key)
    }
    
    func getProperties(of id: Int) {
        
        self.listingAgent.getProperties(of: id)
    }
    
    func getImage(name: String, index: IndexPath) {
        
        self.property.getImage(name: name, index: index)
    }
    
    func getPropertyDetails(of id: Int) {
        
        self.property.getDetails(of: id)
    }
    
    func addProperty(_ prperty: PropertyDTO) {
        
        self.property.add(prperty)
    }
    
    func getValues(of type: String) {
        
        self.type.getValues(of: type)
    }
    
    func doSignIn(email: String, password: String) {
        
        self.user.doSignIn(email: email, password: password)
    }
    
    func dataDidReceive(data: Any) {
        
        switch data {
            
            case let properties as [Property]:
                self.delegate?.processDidComplete(then: properties)
                break
            
            case let propertyImage as (index: IndexPath, data: Data):
                self.delegate?.processDidComplete(then: propertyImage)
                break
            
            case let property as Property:
                self.delegate?.processDidComplete(then: property)
                break
            
            case let values as [TypeValue]:
                self.delegate?.processDidComplete(then: values)
                break
            
            case let user as User:
                self.delegate?.processDidComplete(then: user)
                break
            
            default:
                print("Error [CoreEngine.swift]: Model Type is mismatched.")
                self.delegate?.processDidAbort(reason: "Invalid data.")
        }
    }
    
    func dataDidFail(reason message: String) {
        
        self.delegate?.processDidAbort(reason: message)
    }
}
