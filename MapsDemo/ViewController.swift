//
//  ViewController.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//
import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController {
    //MARK: - Outlets
    //@IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            self.mapView.showsUserLocation = true
            self.mapView.showsCompass = true
            self.mapView.delegate = self
        }
    }
    //MARK: - Class Variables
    lazy var locationHandler = LocationHandler(delegate: self)
    var dataSource: [MKAnnotation] = []
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHandler.getUserLocation()
        getData()
        mapView.delegate = self
    
        self.mapView.register(
            CustomAnnotaitonView.self,
                  forAnnotationViewWithReuseIdentifier: "CustomAnnotaitonView")
              
              self.title = "Location Demo"
          }
        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setCamera()
            self.addAnnotation()
        }
    }
    //MARK: Action Button
    
    @IBAction func searchAction(_ sender: Any) {
        let searchController =  UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate =  self
        present(searchController, animated: true, completion: nil)
    }
    //MARK: - Helper
    func setMapVisibleArea() {
        let coordintate = CLLocationCoordinate2D(latitude: 37.45634, longitude: -122.3456345) // self.mapView.userLocation.coordinate
        let radius = 1000.0
        let region = MKCoordinateRegion(center: coordintate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: true)
    }
    
    func setCamera() {
        let coordinate = self.mapView.userLocation.coordinate
        
        var _ = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setCenter(coordinate, animated: true)
    }
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.mapView.userLocation.coordinate
        annotation.title = "My Location"
        annotation.subtitle = "My Location Subtitle"
        
        mapView.addAnnotation(annotation)
    }
    func getData() {
        guard let url = URL(string: "https://rapidapi.p.rapidapi.com/places?type=CITY&limit=100&skip=0&country=US%2CCA&q=New%20York") else { return }
        
        let headers = [
            "x-rapidapi-host": "spott.p.rapidapi.com",
            "x-rapidapi-key": "e9e886cd17msh32062c46cf93125p1a1b79jsn312df2c8284f"
        ]
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        ServiceManager.manager.request(type: [Place].self, withRequest: request) { result in
            switch result {
            case .success(let cities):
                print(cities)
                self.dataSource.removeAll()
                cities.forEach { self.dataSource.append(CustomAnnotation(place: $0))}
                self.mapView.addAnnotations(self.dataSource)
                break
        case .failure(let error):
                print(error)
            }
        }
    }
}
//MARK: - Extension
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        let view: MKAnnotationView?
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotaitonView") {
            //dequeuedView.annotation = annotation
            //dequeuedView.canShowCallout = true
            dequeuedView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view = dequeuedView
        } else {
            view = CustomAnnotaitonView(annotation: annotation, reuseIdentifier: "CustomAnnotaitonView")
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        }
        /// I mage wasn't  set  reason why it was not showing
        view?.image = UIImage(named: "user_location")
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // what happens when we select the annotation
    }
    
}
extension ViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        print(location)
    }
    func locationDidFail(withError error: Error) {
        print(error)
    }
}

extension ViewController: UISearchBarDelegate {
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityIndicator =  UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped =  true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        //hide searchbar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        //search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error)  in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil  {
                print("error from response") // display Alert
            }
                else {
                    let annotation = self.mapView.annotations
                    //self.mapView.removeAnnotation(annotation)
                    
                    //get data
                    let lattitude =  response?.boundingRegion.center.latitude
                    let longitude = response?.boundingRegion.center.longitude
                    
                    //create annotation
                    let annotaion = MKPointAnnotation()
                    annotaion.title = searchBar.text
                    if let unwrappedLatitude =  lattitude, let unwrappedLongitude =  longitude {
                    annotaion.coordinate = CLLocationCoordinate2DMake(unwrappedLatitude, unwrappedLongitude)
                    } else {print("error from eunwrappin ") /*throw an allert*/ }
                    self.mapView.addAnnotation(annotaion)
                    
                    //Zoomning to location
                    if  let uwarappedLatitude = lattitude, let uwarappedLongigtude = longitude {
                        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: uwarappedLatitude, longitude: uwarappedLongigtude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        let region = MKCoordinateRegion(center: coordinate,span: span)
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            }
            
        }
    }
    

