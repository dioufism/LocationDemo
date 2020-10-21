//
//  GoogleMapsViewController.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import GoogleMaps
import UIKit

class GoogleMapsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    //MARK: - Class Variables
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        googleMapView.delegate = self
        requestUserLocation(locationManager: locationManager, mapView: googleMapView)
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                return
            }
            self.addressLabel.text = lines.joined(separator: "\n")
            UIView.animate(withDuration: 0.25) {
              self.view.layoutIfNeeded()
            }
        }
        let labelHeight = self.addressLabel.intrinsicContentSize.height
        let topInset = self.view.safeAreaInsets.top
        self.googleMapView.padding = UIEdgeInsets(
          top: topInset,
          left: 0,
          bottom: labelHeight,
          right: 0)
    }
}
//MARK: Helper Function
func requestUserLocation(locationManager: CLLocationManager, mapView: GMSMapView) {
    if CLLocationManager.locationServicesEnabled() {
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    } else {
        locationManager.requestWhenInUseAuthorization()
    }
}
//MARK: - Extentions
extension GoogleMapsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.requestLocation()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        googleMapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
// MARK: - GMSMapViewDelegate
extension GoogleMapsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocode(coordinate: position.target)
    }
}
