//
//  UIViewExtension.swift
//  BIIG
//
//  Created by mahbub on 4/4/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static var appImages = [String : UIImage]()
    static var furnishingStates = [TypeValue]()
    static var signedInUser: User? = nil
    static var currentLocationCity: String? = nil
    
    static func getAppImage(_ imageName: String?, type imageType: AppImageType) -> UIImage {
        
        var defaultImage: UIImage? = nil
        
        switch imageType {
            
            case .USER:
                
                defaultImage = UIImage(named: "DefaultUserImage")
                break
            
            case .PROPERTY:
                
                defaultImage = UIImage(named: "DefaultPropertyImage")
                break
            
            default:
                print("No Match")
        }
        
        guard imageName != nil, !imageName!.isEmpty else {
                
            return defaultImage!
        }
        
        if let appImage = UIView.appImages[imageName!] {
            
            return appImage
        }
        
        let url = URL(string: "https://evening-waters-97508.herokuapp.com/" + imageName!)!
        
        do {
            
            let data = try Data(contentsOf: url)
            let appImage = UIImage(data: data)!
            UIView.appImages[imageName!] = appImage
            
            return appImage
            
        } catch let err {
            print("Image Error: \(err.localizedDescription)")
        }
        
        return defaultImage!
    }
 
}

enum AppImageType {
    
    case USER, PROPERTY
}
