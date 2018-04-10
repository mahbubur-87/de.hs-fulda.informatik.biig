//
//  MainMenuViewController.swift
//  BIIG
//
//  Created by mahbub on 3/19/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation
import UIKit

class MainMenuController: UICollectionViewController {
    
    let cellIdentifier = "MainMenuCell"
    let mainMenuIcons = ["for-sale", "for-rent", "listing-agent"/*, "sign-up", "sign-in"*/, "about-us", "contact-us"]
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.mainMenuIcons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! MainMenuCollectionCell
        
        cell.mainMenuButton.tag = indexPath.item + 1
        cell.mainMenuButton.setBackgroundImage(UIImage(named: self.mainMenuIcons[indexPath.item] + ".png"), for: UIControlState.normal)
        cell.mainMenuButton.addTarget(self, action: #selector(MainMenuController.enterMenu(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func enterMenu(_ sender: UIButton) {
        
        switch sender.tag {
            
            case 1 ... 2:
            
                let propertyFinder = self.storyboard?.instantiateViewController(withIdentifier: "PropertyList") as! PropertyListController
                propertyFinder.actAs = .PROPERTY_FINDER
                self.navigationController?.pushViewController(propertyFinder, animated: true)
                
                break
        
            case 3:
                
                let listingAgentProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfileController
                listingAgentProfile.userType = .LISTING_AGENT
                self.navigationController?.pushViewController(listingAgentProfile, animated: true)
                
                break
            
//            case 5:
//
//                let userSignIn = self.storyboard?.instantiateViewController(withIdentifier: "UserSignIn") as! UserSignInController
//                userSignIn.controllerStoryboardId = "MainMenu"
//                self.navigationController?.pushViewController(userSignIn, animated: true)
//
//                break
            
            default:
                print("No Match")
        }
    }
}

