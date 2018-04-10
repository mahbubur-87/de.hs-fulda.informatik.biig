//
//  PropertyDTO.swift
//  BIIG
//
//  Created by mahbub on 4/7/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

struct PropertyDTO: Encodable {
    
    var employeeId: Int
    var title: String
    var price: Double
    var overview: String
    var desc: String
    var size: Int
    var numberofrooms: Int
    var furnishingstate: Int
    var streetname: String
    var housenumber: String
    var country: String
    var state: String
    var plz: Int
    var city: String
    var image1: String
    var image1Format: String
    var image2: String?
    var image2Format: String?
    var image3: String?
    var image3Format: String?
        
}
