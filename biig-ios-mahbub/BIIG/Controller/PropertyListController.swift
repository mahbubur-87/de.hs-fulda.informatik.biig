//
//  PropertyListController.swift
//  BIIG
//
//  Created by mahbub on 1/17/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit
import CoreLocation

class PropertyListController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, CLLocationManagerDelegate, EngineDelegate {
    
    let locationManager = CLLocationManager()
    let app = CoreEngine()
    
    var actAs: ControllerActAs = ControllerActAs.PROPERTY_FINDER
    var properties = [Property]()
    
    @IBOutlet weak var propertyCollectionView: UICollectionView!
    @IBOutlet weak var propertySearchKey: UITextField!
    @IBOutlet weak var propertyCount: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var addPropertyButton: UIButton!
    
    @IBAction func findProperties(_ sender: UIButton) {
    
        let key = self.propertySearchKey.text!
        print("Search Key: " + key)
        app.findProperties(by: key)
    }
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
    
        getCurrentLocation()
    }
    
    @IBAction func getPropertyDetails(_ sender: UIButton) {
    
        let propertyId = sender.tag
        self.app.getPropertyDetails(of: propertyId)
    }
    
    @IBAction func addNewProperty(_ sender: UIButton) {
    
        guard UIView.furnishingStates.isEmpty else {
        
            let propertyAdd = self.storyboard?.instantiateViewController(withIdentifier: "PropertyForm") as! PropertyFormController
            self.navigationController?.pushViewController(propertyAdd, animated: true)
            return
        }
        
        self.app.getValues(of: "FURNISHING_STATE")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        self.navigationItem.rightBarButtonItem = homeButton
        
        self.app.delegate = self
        
        self.propertyCollectionView.delegate = self
        self.propertyCollectionView.dataSource = self
        
        switch self.actAs {
            
            case .PROPERTY_FINDER:
                
                self.pageTitle.text = "FIND YOUR DREAM PROPERTY WITH BiiG"
                
                self.propertySearchKey.isHidden = false
                self.searchButton.isHidden = false
                self.currentLocationButton.isHidden = false
                
                self.addPropertyButton.isHidden = true
                self.propertyCount.isHidden = true
                self.propertyCollectionView.isHidden = true
                
                self.locationManager.delegate = self
                self.getCurrentLocation()
                
                break
            
            case .LISTING_AGENT_PROPERTY_LIST:
                
                self.pageTitle.text = "Listing Agent's Property List"
                
                self.propertySearchKey.isHidden = true
                self.searchButton.isHidden = true
                self.currentLocationButton.isHidden = true
                
                self.addPropertyButton.isHidden = false
                self.propertyCount.isHidden = false
                self.propertyCollectionView.isHidden = false
                
                self.propertyCount.text = "Total \(self.properties.count) properties are listed."
                
                break
            
            default:
                print("No Match")
        }
    }
    
    func getCurrentLocation() {
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestLocation()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCollectionCell
        
        cell.details.tag = self.properties[indexPath.item].id
        cell.title.text = self.properties[indexPath.item].title!
        cell.price.text = "\(self.properties[indexPath.item].numberofrooms!) rooms, \(self.properties[indexPath.item].size!) m.sq, €\(self.properties[indexPath.item].price!)"
        cell.image.image = UIView.getAppImage(self.properties[indexPath.item].image1!, type: .PROPERTY)
        cell.yearbuilt.text = "Built: \(self.properties[indexPath.item].yearbuilt!)"
        cell.posted.text = "Posted: " + self.properties[indexPath.item].posted!
        cell.address.text = self.properties[indexPath.item].street! + " " + self.properties[indexPath.item].housenumber! + ", \(self.properties[indexPath.item].plz!) " + self.properties[indexPath.item].city! + ", " + self.properties[indexPath.item].state! + ", " + self.properties[indexPath.item].country!
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard !locations.isEmpty else {
            
            print("Locations Array is empty, no Location is found.")
            return
        }
        
        let currentLocation = locations.last!
        
        print("Current Location: \(currentLocation.description)")
        print("Current Location Coordinate: \(currentLocation.coordinate)")
        print("Current Location Latitude: \(currentLocation.coordinate.latitude.description)")
        print("Current Location Longitude: \(currentLocation.coordinate.longitude.description)")
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            
            if let error = error {
                
                print("Error during Reverse Geocode Location.")
                print("Error: \(error.localizedDescription)")
            }
            
            if let placemarks = placemarks {
                
                guard !placemarks.isEmpty else {
                    
                    print("Placemarks Array is empty, no Placemark is found.")
                    return
                }
                
                let currentPlacemark = placemarks.first!
                
                print("Name: \(currentPlacemark.name!)")
                print("Street: \(currentPlacemark.thoroughfare!)")
                print("Postal Code: \(currentPlacemark.postalCode!)")
                print("City: \(currentPlacemark.locality!)")
                print("State: \(currentPlacemark.administrativeArea!)")
                print("Country: \(currentPlacemark.country!)")
                
                UIView.currentLocationCity = currentPlacemark.locality
                
                // get properties from current location's postal area
                if let postalCode = currentPlacemark.postalCode {
                    
                    DispatchQueue.main.async {
                        
                        print("Search Key: " + postalCode)
                        self.propertySearchKey.text = postalCode
                        self.app.findProperties(by: postalCode)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Unable to get Current Location Data.")
        print("Error: \(error.localizedDescription)")
    }
    
    func reloadProperties(_ properties: [Property]) {
        
        self.properties = properties
        
        self.propertyCount.isHidden = false
        self.propertyCount.text = "Total \(self.properties.count) properties are found."
        
        self.propertyCollectionView.isHidden = false
        self.propertyCollectionView.reloadData()
    }
    
    func processDidComplete(then dto: Any) {
        
        DispatchQueue.main.async {
            
            switch dto {
                
                case let properties as [Property]:
                    
                    self.reloadProperties(properties)
                    break
                
                case let propertyImage as (index: IndexPath, data: Data):
                    
                    let cell = self.propertyCollectionView.cellForItem(at: propertyImage.index) as! PropertyCollectionCell
                    cell.image.image = UIImage(data: propertyImage.data)!

                    break
                
                case let property as Property:
                    
                    let propertyDetails = self.storyboard?.instantiateViewController(withIdentifier: "PropertyDetails") as! PropertyDetailsController
                    propertyDetails.property = property
                    
                    self.navigationController?.pushViewController(propertyDetails, animated: true)
                    
                    break
                
                case let typeValues as [TypeValue]:
                    
                    let propertyAdd = self.storyboard?.instantiateViewController(withIdentifier: "PropertyForm") as! PropertyFormController
                    UIView.furnishingStates = typeValues
                    
                    self.navigationController?.pushViewController(propertyAdd, animated: true)
                    
                    break
                
                default:
                    print("No Match")
            }
        }
    }
    
    func processDidAbort(reason message: String) {
        
        DispatchQueue.main.async {
            
            self.propertyCollectionView.isHidden = true
            
            let abortAlert = UIAlertController(title: "Process is aborted.", message: "Reason: " + message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            abortAlert.addAction(cancelAction)
            self.present(abortAlert, animated: true)
        }
    }
    
}

enum ControllerActAs {
    
    case PROPERTY_FINDER, LISTING_AGENT_PROPERTY_LIST
}
