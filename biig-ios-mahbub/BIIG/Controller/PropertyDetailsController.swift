//
//  PropertyDetailsController.swift
//  BIIG
//
//  Created by mahbub on 4/1/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit
import CoreLocation

class PropertyDetailsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, EngineDelegate {

    let app = CoreEngine()
    
    let detailSections = ["Overview", "Description", "Features"]
    
    var property: Property? = nil
    var propertyImageNames = [String]()
    
    @IBOutlet weak var propertyTitle: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var roomSizePrice: UILabel!
    @IBOutlet weak var contactAgent: UIButton!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var otherInformation: UITableView!
    
    @IBAction func showPropertyImage(_ sender: UIButton) {
        
        let imageViewer = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewer") as! ImageController
        imageViewer.imageToView = sender.backgroundImage(for: UIControlState.normal)
        self.navigationController?.pushViewController(imageViewer, animated: true)
    }
    
    @IBAction func showPropertyLocationOnMap(_ sender: UIButton) {
        
        CLGeocoder().geocodeAddressString(self.address.text!) { placemarks, error in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    
                    self.processDidAbort(reason: error.localizedDescription)
                    return
                }
                
                if let placemarks = placemarks {
                    
                    guard !placemarks.isEmpty else {
                        
                        self.processDidAbort(reason: "Placemarks Array is empty, no Placemark is found.")
                        return
                    }
                    
                    let propertyPlacemark = placemarks.first!
                    let propertyArea = propertyPlacemark.location!.coordinate
                    
                    let googleMapViewer = self.storyboard?.instantiateViewController(withIdentifier: "GoogleMapViewer") as! GoogleMapViewController
                    googleMapViewer.propertyTitle = self.propertyTitle.text
                    googleMapViewer.propertyArea = propertyArea
                    googleMapViewer.propertyCity = self.property!.city
                    
                    self.navigationController?.pushViewController(googleMapViewer, animated: true)
                }
            }
        }
    }
    
    @IBAction func showAgentInformation(_ sender: UIButton) {
        
        let listingAgent = User(id: 11, name: self.property!.agent_name, image: self.property!.agent_image, phone: self.property!.agent_phone, company: self.property!.agent_company, designation: self.property!.agent_designation, customer: nil, employee: 11)
        
        let userInformationController = self.storyboard?.instantiateViewController(withIdentifier: "UserInformation") as! UserInformationController
        userInformationController.infoPageTitle = "Listing Agent Information"
        userInformationController.user = listingAgent
        
        self.navigationController?.pushViewController(userInformationController, animated: true)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        self.navigationItem.rightBarButtonItem = homeButton
        
        self.app.delegate = self
        
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        
        self.otherInformation.delegate = self
        self.otherInformation.dataSource = self
        
        self.displayProperty()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.propertyImageNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyImage", for: indexPath) as! PropertyImageCollectionCell
        cell.propertyImage.setBackgroundImage(UIView.getAppImage(self.propertyImageNames[indexPath.item], type: .PROPERTY), for: UIControlState.normal)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return self.detailSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return "Features" == self.detailSections[section] ? 4 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerFrame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30)
        let headerView = UIView(frame: headerFrame)
        headerView.backgroundColor = UIColor.lightGray
        
        let headerTitle = UILabel(frame: headerFrame)
        headerTitle.text = "  " + self.detailSections[section] + ":"
        
        headerView.addSubview(headerTitle)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyOtherInfo", for: indexPath) as! OtherInformationTableCell
        
        var infoText: String? = nil
        
        switch self.detailSections[indexPath.section] {

            case "Overview":
                
                infoText = self.property!.overview
                break

            case "Description":
                
                infoText = self.property!.description
                break

            case "Features" where indexPath.row == 0:
                
                infoText = "Type of Property: " + self.property!.typeofproperty!
                break

            case "Features" where indexPath.row == 1:
                
                infoText = "Furnishing State: " + self.property!.furnishingstate!
                break

            case "Features" where indexPath.row == 2:
                
                infoText = "Year Built: \(self.property!.yearbuilt!)"
                break

            case "Features" where indexPath.row == 3:
                
                infoText = "Published In: " + self.property!.posted!
                break

            default:
                print("No Match")
        }
        
        cell.information.text = infoText
        
        return cell
    }
    
    func displayProperty() {

        self.propertyTitle.text = self.property!.title!
        self.address.text = self.property!.street! + " " + self.property!.housenumber! + ", \(self.property!.plz!) " + self.property!.city! + ", " + self.property!.state! + ", " + self.property!.country!
        self.roomSizePrice.text = "\(self.property!.numberofrooms!) rooms, \(self.property!.size!) m.sq, €\(self.property!.price!)"
        self.contactAgent.setTitle("[Agent: " + self.property!.agent_name! + "]", for: UIControlState.normal)
        
        if let image1 = self.property!.image1, !image1.isEmpty {

            self.propertyImageNames.append(image1)
        }

        if let image2 = self.property!.image2, !image2.isEmpty {

            self.propertyImageNames.append(image2)
        }

        if let image3 = self.property!.image3, !image3.isEmpty {

            self.propertyImageNames.append(image3)
        }

        self.imageCollection.reloadData()
    }
    
    func processDidComplete(then dto: Any) {
        
        DispatchQueue.main.async {
            
            switch dto {
                
//                case let property as Property:
//
//                    self.property = property
//                    self.displayProperty()
//                    break
                
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
}
