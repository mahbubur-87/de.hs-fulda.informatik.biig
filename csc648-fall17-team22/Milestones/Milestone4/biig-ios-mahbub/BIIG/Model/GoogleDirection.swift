//
//  GoogleDirection.swift
//  BIIG
//
//  Created by mahbub on 4/9/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

struct GoogleDirection: Decodable {
    
    var routes: [GoogleRoute]
    var status: String
}
