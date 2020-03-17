//
//  GoogleMapViewController.swift
//  BIIG
//
//  Created by mahbub on 4/9/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, EngineDelegate {

    let navigation = NEngine()
    
    let locationManager = CLLocationManager()
    
    var googleDirection: GoogleDirection? = nil
    var propertyMarker: GMSMarker? = nil
    var propertyArea: CLLocationCoordinate2D? = nil
    var propertyTitle: String? = nil
    var propertyCity: String? = nil
    var routePolylines = [GMSPolyline]()
    
    let universityCampusArea = CLLocationCoordinate2D(latitude: 50.5650077, longitude: 9.6853589)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var rightBarButtons = [UIBarButtonItem]()
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        rightBarButtons.append(homeButton)

        if let prptyCity = self.propertyCity,
            let currentCity = UIView.currentLocationCity,
            prptyCity == currentCity {

            let showDirectionsButton = UIBarButtonItem(title: "SHOW DIRECTIONS", style: .plain, target: self, action: #selector(GoogleMapViewController.showDirectionsToPropertyFromCurrentLocation(_:)))

            rightBarButtons.append(showDirectionsButton)
        }

        self.navigationItem.rightBarButtonItems = rightBarButtons
        
        let cameraPostion = GMSCameraPosition.camera(withLatitude: self.propertyArea!.latitude, longitude: self.propertyArea!.longitude, zoom: 18)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: cameraPostion)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        
        self.propertyMarker = GMSMarker(position: self.propertyArea!)
        self.propertyMarker!.title = self.propertyTitle
        self.propertyMarker!.map = mapView
        
        self.view = mapView

    }
    
    @IBAction func showDirectionsToPropertyFromCurrentLocation(_ sender: UIBarButtonItem) {
    
        self.navigation.delegate = self

        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.activityType = CLActivityType.automotiveNavigation
        self.locationManager.distanceFilter = 100
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!

        (self.view as! GMSMapView).animate(toLocation: currentLocation.coordinate)

        self.routePolylines.forEach { routePolyline in routePolyline.map = nil }
        self.routePolylines.removeAll()

        let origin = currentLocation.coordinate
        let destinations = [self.propertyMarker!.position]

        self.navigation.getDirectionFromDistanceMatrix(origins: [origin], destinations: destinations)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        print("\nTap At: \(coordinate)")

        let tapMarker = GMSMarker(position: coordinate)
        tapMarker.title = "\(coordinate.latitude), \(coordinate.longitude)"
        tapMarker.map = mapView

        self.routePolylines.forEach { routePolyline in routePolyline.map = nil }
        self.routePolylines.removeAll()

        let destinations = [self.propertyMarker!.position]

        self.navigation.getDirectionFromDistanceMatrix(origins: [coordinate], destinations: destinations)
    }
    
    func showDirectionsToProperty(_ steps: [GoogleStep]) {

        // draw line from current location to property
        DispatchQueue.main.async {

            let mapView = self.view as! GMSMapView
            let path = GMSMutablePath()

            steps.forEach { step in

                path.add(CLLocationCoordinate2D(latitude: step.start_location.lat, longitude: step.start_location.lng))
                path.add(CLLocationCoordinate2D(latitude: step.end_location.lat, longitude: step.end_location.lng))
            }

            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = UIColor.green
            polyline.zIndex = 1
            polyline.map = mapView

            self.routePolylines.append(polyline)
        }
    }
    
    func processDidComplete(then dto: Any) {
        
        switch dto {
            
        case let steps as [GoogleStep]:
            self.showDirectionsToProperty(steps)
            break
            
        default: print("No match.")
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
