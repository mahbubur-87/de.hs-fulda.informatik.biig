//
//  User.swift
//  BIIG
//
//  Created by mahbub on 1/18/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var id: Int
    var name: String?
    var image: String?
    var phone: String?
    var company: String?
    var designation: String?
    var customer: Int?
    var employee: Int?
}

enum UserType {
    
    case LISTING_AGENT, CUSTOMER
}
