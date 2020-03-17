//
//  GoogleDistance.swift
//  BIIG
//
//  Created by mahbub on 4/9/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

struct GoogleDistance: Decodable {
    
    var destination_addresses: [String]
    var origin_addresses: [String]
    var rows: [GoogleRow]
    var status: String
    
}
