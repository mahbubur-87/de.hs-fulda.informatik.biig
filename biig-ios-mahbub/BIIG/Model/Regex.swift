//
//  Regex.swift
//  BIIG
//
//  Reference: from NSHipster - http://nshipster.com/swift-literal-convertible/
//
//  Created by mahbub on 4/2/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation

struct Regex {
    
    let pattern: String
    let options: NSRegularExpression.Options
    
    private var matcher: NSRegularExpression? {
        
        do {
        
            return try NSRegularExpression(pattern: self.pattern, options: self.options)
        
        } catch let regexError {
            
            print("\nRegex Error: \(regexError)\n")
            return nil
        }
    }
    
    init(pattern: String, options: NSRegularExpression.Options = []) {
        
        self.pattern = pattern
        self.options = options
    }
    
    func match(_ string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
    
        return self.matcher!.numberOfMatches(in: string, options: options, range: NSMakeRange(0, string.utf16.count)) != 0
    }
    
}
