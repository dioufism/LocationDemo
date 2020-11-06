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
    private var searchedTypes = ["bakery", "bar", "cafe", "grocery", "restaurant"]
    let dataProvider = GoogleDataProvider()
    let searchRadius: Double = 1000
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        googleMapView.delegate = self
        requestUserLocation(locationManager: locationManager, googleMapView: googleMapView)
    }
    //MARK: - Helper Function
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
    //MARK: - Segway
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard
        let navigationController = segue.destination as? UINavigationController,
        let controller = navigationController.topViewController as? TypesTableViewController
        else {
          return
      }
      controller.selectedTypes = searchedTypes
      controller.delegate = self
    }
    //MARK: - Helper Function 2
    func fetchPlaces(near coordinate: CLLocationCoordinate2D){
        googleMapView.clear()
      dataProvider.fetchPlaces(
        near: coordinate,
        radius:searchRadius,
        types: searchedTypes
      ) { places in
        places.forEach { place in
          let marker = PlaceMarker(place: place, availableTypes: self.searchedTypes)
          marker.map = self.googleMapView
        }
      }
    }
}
//MARK: - Helper Function
func requestUserLocation(locationManager: CLLocationManager, googleMapView: GMSMapView) {
    if CLLocationManager.locationServicesEnabled() {
        locationManager.requestLocation()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
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
        fetchPlaces(near: location.coordinate)
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
// MARK: - TypesTableViewControllerDelegate
extension GoogleMapsViewController: TypesTableViewControllerDelegate {
  func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = controller.selectedTypes.sorted()
    dismiss(animated: true)
    fetchPlaces(near: googleMapView.camera.target)
  }
}
//MARK: - Class Action Buttons
extension GoogleMapsViewController {
  @IBAction func refreshPlaces(_ sender: Any) {
    fetchPlaces(near: googleMapView.camera.target)
  }
}
