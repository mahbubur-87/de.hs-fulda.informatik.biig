//
//  FloatExtension.swift
//  BIIG
//
//  Created by mahbub on 4/8/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

extension Float {
    
    static func parseFloat(from value: String) throws -> Float {
        
        guard let parsedValue = Float(value),
            !parsedValue.isNaN else {
                
                throw DataTypeError.INVALID_FLOAT(reason: "Invalid Number.")
        }
        
        return parsedValue
    }
    
}
