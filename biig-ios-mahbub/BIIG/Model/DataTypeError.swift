//
//  DataTypeError.swift
//  BIIG
//
//  Created by mahbub on 4/8/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

enum DataTypeError: Error {
    
    case INVALID_INT(reason: String)
    case INVALID_FLOAT(reason: String)
    case INVALID_DOUBLE(reason: String)
}
