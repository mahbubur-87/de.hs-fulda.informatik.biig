//
//  EngineDelegate.swift
//  BIIG
//
//  Created by mahbub on 3/21/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

protocol EngineDelegate {
    
    func processDidComplete(then dto: Any)
    
    func processDidAbort(reason message: String)
    
}
