//
//  ImageController.swift
//  BIIG
//
//  Created by mahbub on 4/6/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit

class ImageController: UIViewController {

    var imageToView: UIImage? = nil
    
    @IBOutlet weak var imageCanvas: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        self.navigationItem.rightBarButtonItem = homeButton
        
        self.imageCanvas.image = self.imageToView
    }

}
