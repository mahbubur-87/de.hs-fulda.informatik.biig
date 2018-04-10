//
//  UserInformationController.swift
//  BIIG
//
//  Created by mahbub on 4/7/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit

class UserInformationController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userDetailsTitles = ["Name", "Phone", "Company", "Designation"]
    
    var infoPageTitle: String = "User Information"
    var user: User? = nil
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userDetails: UITableView!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        self.navigationItem.rightBarButtonItem = homeButton
        
        self.userDetails.delegate = self
        self.userDetails.dataSource = self
        
        self.pageTitle.text = self.infoPageTitle
        self.userImage.image = UIImage(named: "ListingAgentImage") //UIView.getAppImage(self.user?.image, type: .USER)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.userDetailsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath)
        
        cell.subviews.forEach { subView in
            
            subView.removeFromSuperview()
        }
        
        let fieldTitle = UILabel(frame: CGRect(x: 15, y: 12, width: 110, height: 25))
        fieldTitle.font = UIFont.systemFont(ofSize: CGFloat(17), weight: .semibold)
        fieldTitle.text = self.userDetailsTitles[indexPath.row]
        
        let fieldValue = UILabel(frame: CGRect(x: 132, y: 12, width: tableView.bounds.size.width - 50, height: 25))
        
        switch fieldTitle.text! {
            
            case "Name":
            
                fieldValue.text = self.user!.name
                break
            
            case "Phone":
                
                fieldValue.text = self.user!.phone
                break
            
            case "Company":
                
                fieldValue.text = self.user!.company ?? "BiiG"
                break
            
            case "Designation":
                
                fieldValue.text = self.user!.designation ?? "Listing Agent"
                break
            
            default:
                print("No Match")
        }
        
        cell.addSubview(fieldTitle)
        cell.addSubview(fieldValue)
        
        return cell
    }
    
}
