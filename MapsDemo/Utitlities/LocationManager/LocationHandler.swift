//
//  LocationHandler.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import CoreLocation
import UIKit
protocol LocationHandlerDelegate: AnyObject, AlertProtocol {
    func received(location: CLLocation)
    func locationDidFail(withError error: Error)
}

class LocationHandler: NSObject {
    private lazy var locationManager: CLLocationManager = {
        let locationM = CLLocationManager()
        locationM.delegate = self
        locationM.desiredAccuracy = kCLLocationAccuracyBest
        locationM.pausesLocationUpdatesAutomatically = true
        locationM.distanceFilter = 5
        locationM.showsBackgroundLocationIndicator = true
        return locationM
    }()
    
    var delegate: LocationHandlerDelegate?
    
    init(delegate: LocationHandlerDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    func getUserLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            delegate?.showAlert(title: "Location Disabled", message: "Please enable your location services", buttons: [.cancel, .settings]) { alert, type in
                switch type {
                case .cancel:
                    print("cancel pressed")
                case .settings:
                    UIApplication.shared.openSettings()
                default:
                    break
                }
            }
            return
        }
        checkAndPromptLocationAuthorization()
    }
    
    private func checkAndPromptLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            delegate?.showAlert(title: "Location Denied", message: "Please give access to your location.", buttons: [.cancel, .settings]) { alert, type in
                switch type {
                case .settings:
                    UIApplication.shared.openSettings()
                default:
                    break
                }
            }
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}

extension LocationHandler: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        delegate?.received(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationDidFail(withError: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAndPromptLocationAuthorization()
    }
}
