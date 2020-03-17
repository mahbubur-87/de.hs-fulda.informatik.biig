//
//  UIViewControllerExtension.swift
//  BIIG
//
//  Created by mahbub on 4/9/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @IBAction func goToHome(_ sender: UIBarButtonItem) {
        
        let mainMenu = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
        self.navigationController?.pushViewController(mainMenu, animated: true)
    }
    
}
