//
//  StringExtension.swift
//  BIIG
//
//  Reference: http://www.lesstroud.com/swift-using-regex-in-switch-statements/
//
//  Created by mahbub on 4/2/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

extension String {
    
    func match(_ regex: Regex) -> Bool {
        return regex.match(self)
    }
    
    static func ~=(pattern: Regex, matchable: String) -> Bool {
        return matchable.match(pattern)
    }
}
