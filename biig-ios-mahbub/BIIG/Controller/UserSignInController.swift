//
//  UserSignInController.swift
//  BIIG
//
//  Created by mahbub on 4/9/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit

class UserSignInController: UIViewController, EngineDelegate {

    let app = CoreEngine()
    
    var controllerStoryboardId: String? = nil
    var userPassword: String = ""
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func validateEmail(_ sender: UITextField) {
        
        guard let email = sender.text,
            email.match(Regex(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")) else {
            
            sender.text = nil
            self.processDidAbort(reason: "Invalid Email.")
            return
        }
    }
    @IBAction func changeToStar(_ sender: UITextField) {
        
        guard let password = sender.text,
            let passwordLastChar = password.last else {
                
               return
        }
        
        self.userPassword = self.userPassword + String(passwordLastChar)
        
        var stars = ""
        
        password.forEach { pwd in
            
            stars = stars + "*"
        }
        
        sender.text = stars
    }
    
    @IBAction func doSignIn(_ sender: UIButton) {
        
        self.activityIndicator.startAnimating()
        self.app.doSignIn(email: self.inputEmail.text!, password: self.userPassword)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        self.navigationItem.rightBarButtonItem = homeButton
        
        self.app.delegate = self
    }
    
    func processDidComplete(then dto: Any) {
        
        DispatchQueue.main.async {
            
            switch dto {
                
                case let user as User:

                    self.activityIndicator.stopAnimating()
                    
                    UIView.signedInUser = user

                    let successMessage = UIAlertController(title: "Successful", message: "Sign In is Successful.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Done", style: .cancel) { alert in
                        
                        let previousController = self.storyboard?.instantiateViewController(withIdentifier: self.controllerStoryboardId!)
                        self.navigationController?.pushViewController(previousController!, animated: true)
                    }
                    successMessage.addAction(okAction)

                    self.present(successMessage, animated: true)

                    break
                
                default:
                    print("No Match")
            }
        }
    }
    
    func processDidAbort(reason message: String) {
        
        DispatchQueue.main.async {
            
            self.activityIndicator.stopAnimating()
            
            let abortAlert = UIAlertController(title: "Process is aborted.", message: "Reason: " + message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            abortAlert.addAction(cancelAction)
            self.present(abortAlert, animated: true)
        }
    }

}
