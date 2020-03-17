//
//  RESTServiceDelegate.swift
//  BIIG
//
//  Created by mahbub on 1/18/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

protocol RESTServiceDelegate {
    
    func dataDidReceive(data: Any)
    
    func dataDidFail(reason message: String)
    
}

