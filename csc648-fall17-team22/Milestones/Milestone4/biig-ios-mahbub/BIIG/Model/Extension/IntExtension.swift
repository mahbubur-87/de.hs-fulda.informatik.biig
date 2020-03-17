//
//  IntExtension.swift
//  BIIG
//
//  Created by mahbub on 4/8/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

extension Int {
    
    static func parseInt(from value: String) throws -> Int {
        
        guard let parsedValue = Int(value) else {
                
                throw DataTypeError.INVALID_INT(reason: "Invalid Number.")
        }
        
        return parsedValue
    }
    
}
