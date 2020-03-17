//
//  UserService.swift
//  BIIG
//
//  Created by mahbub on 4/8/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

class UserService: RESTService {
    
    static private let networkProtocol = "https"
    static private let host = "evening-waters-97508.herokuapp.com"
    
    init() {
        
        super.init(with: UserService.networkProtocol, host: UserService.host)
    }
    
    override func callbackAfterCompletion(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            
            print("Response Error [UserService.swift]: \(error!.localizedDescription)")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }
        
        guard let data = data else {
            
            print("Response Error [UserService.swift]: No Data is Found.")
            self.delegate?.dataDidFail(reason: "Invalid Response from BiiG REST API.")
            return
        }
        
        do {
            
            var decodedData: Any? = nil
            
            switch response!.url!.path {
                
                case "/user/login":
                    
                    decodedData = try JSONDecoder().decode(User.self, from: data)
                    break
                
                default:
                    print("No Match.")
            }
            
            self.delegate?.dataDidReceive(data: decodedData!)
            
        } catch let jsonError {
            
            print("JSON Decode Error [UserService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to decode JSON message from BiiG REST API.")
        }
    }
    
    func doSignIn(email: String, password: String) {
        
        guard !email.isEmpty else {
            
            print("Service Error [UserService.swift]: Email is invalid.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        guard !password.isEmpty else {
            
            print("Service Error [UserService.swift]: Password is invalid.")
            self.delegate?.dataDidFail(reason: "Invalid Request to BiiG REST API.")
            return
        }
        
        let requestUrl = "/user/login"
        let url = self.generateURL(using: requestUrl)
        let userSignIn = UserSignIn(username: email, password: password)
        
        do {
            
            let data = try JSONEncoder().encode(userSignIn)
            self.processPOST(for: url, payload: data)
            
        } catch let jsonError {
            
            print("JSON Encode Error [UserService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to encode JSON message for BiiG REST API.")
        }
        
    }
    
}

struct UserSignIn: Encodable {
    
    var username: String
    var password: String
    
}
