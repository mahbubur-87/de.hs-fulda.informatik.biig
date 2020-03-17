//
//  Property.swift
//  BIIG
//
//  Created by mahbub on 1/18/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

struct Property: Decodable {
    
    var id: Int
    var title: String?
    var yearbuilt: Int?
    var price: Double?
    var image1: String?
    var image2: String?
    var image3: String?
    var housenumber: String?
    var street: String?
    var plz: Int?
    var city: String?
    var state: String?
    var country: String?
    var posted: String?
    var numberofrooms: Int?
    var size: Int?
    var user: Int?
    var overview: String?
    var description: String?
    var typeofproperty: String?
    var usage: String?
    var furnishingstate: String?
    var agent_name: String?
    var agent_image: String?
    var agent_phone: String?
    var agent_company: String?
    var agent_designation: String?
    
}
