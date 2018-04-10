//
//  UserProfileController.swift
//  BIIG
//
//  Created by mahbub on 4/7/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource, EngineDelegate {

    let app = CoreEngine()
    let listingAgentMenus = ["Dashboard", "Personal Information", "Property", "Sales", "Sign Out"]
    let customerMenus = ["Dashboard", "Personal Information", "Favorite", "Sign Out"]
    
    var userType: UserType = UserType.LISTING_AGENT
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileMenuItems: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func enterMenu(_ sender: UIButton) {
        
        let menu = sender.title(for: .normal) ?? "Dashboard"
        
        switch self.userType {
            
            case .LISTING_AGENT:
                
                self.enterListingAgentMenu(menu)
                break
            
            case .CUSTOMER:
                
                self.enterCustomerMenu(menu)
                break
            
            default:
                print("No Match")
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        self.navigationItem.rightBarButtonItem = homeButton
        
        self.app.delegate = self
        
        self.profileMenuItems.delegate = self
        self.profileMenuItems.dataSource = self
        
        switch self.userType {
            
            case .LISTING_AGENT:
                
                self.pageTitle.text = "Listing Agent Profile"
                break
            
            case .CUSTOMER:
                
                self.pageTitle.text = "Customer Profile"
                break
            
            default:
                print("No Match")
        }
        
        self.userName.text = "Rohan Deo"
        self.userImage.image = UIImage(named: "ListingAgentImage") //UIView.getAppImage(nil, type: .USER)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 1
        
        switch self.userType {
            
            case .LISTING_AGENT:
                
                numberOfRows = self.listingAgentMenus.count
                break
            
            case .CUSTOMER:
                
                numberOfRows = self.customerMenus.count
                break
            
            default:
                print("No Match")
        }
        
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath) as! ProfileMenuTableCell
        cell.menuItem.setTitle(self.listingAgentMenus[indexPath.row], for: UIControlState.normal)
        return cell
    }
    
    func processDidComplete(then dto: Any) {
        
        DispatchQueue.main.async {
            
            switch dto {
                
            case let properties as [Property]:
                
                self.activityIndicator.stopAnimating()
                
                let propertyList = self.storyboard?.instantiateViewController(withIdentifier: "PropertyList") as! PropertyListController
                propertyList.actAs = .LISTING_AGENT_PROPERTY_LIST
                propertyList.properties = properties
                self.navigationController?.pushViewController(propertyList, animated: true)
                
                break
                
            default:
                print("No Match")
            }
        }
    }
    
    func processDidAbort(reason message: String) {
        
        DispatchQueue.main.async {
            
            let abortAlert = UIAlertController(title: "Process is aborted.", message: "Reason: " + message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            abortAlert.addAction(cancelAction)
            self.present(abortAlert, animated: true)
        }
    }
    
    func enterListingAgentMenu(_ menu: String) {
        
        switch menu {
            
            case "Dashboard":
                
                break
            
            case "Personal Information":
                
                let listingAgent = User(id: 11, name: "Rohan Deo", image: "", phone: "+4915211413724", company: "BiiG Real Estate", designation: "Listing Agent", customer: nil, employee: 11)
                
                let userInformationController = self.storyboard?.instantiateViewController(withIdentifier: "UserInformation") as! UserInformationController
                userInformationController.infoPageTitle = "Listing Agent Information"
                userInformationController.user = listingAgent
                
                self.navigationController?.pushViewController(userInformationController, animated: true)
                
                break
            
            case "Property":
                
                self.activityIndicator.startAnimating()
                self.app.getProperties(of: 11) // listing agent id
                
                break
            
            case "Sales":
                
                break
            
            case "Sign Out":
                
                break
            
            default:
                print("No Match")
        }
    }
    
    func enterCustomerMenu(_ menu: String) {
        
        switch menu {
            
            case "Dashboard":
                
                break
            
            case "Personal Information":
                
                break
            
            case "Favorite":
                
                break
            
            case "Sign Out":
                
                break
            
            default:
                print("No Match")
        }
    }
    
}
