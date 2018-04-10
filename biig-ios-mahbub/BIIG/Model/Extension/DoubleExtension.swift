//
//  DoubleExtension.swift
//  BIIG
//
//  Created by mahbub on 4/8/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

extension Double {
    
    static func parseDouble(from value: String) throws -> Double {
        
        guard let parsedValue = Double(value),
            !parsedValue.isNaN else {

            throw DataTypeError.INVALID_DOUBLE(reason: "Invalid Number.")
        }
        
        return parsedValue
    }
    
}
