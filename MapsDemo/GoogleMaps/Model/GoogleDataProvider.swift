//
//  GoogleDataProvider.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/22/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import UIKit
import CoreLocation

import UIKit
import CoreLocation

typealias PlacesCompletion = ([GooglePlace]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class GoogleDataProvider {
  private var photosDictionary: [String: UIImage] = [:]
  private var placesTask: URLSessionDataTask?
  private var session: URLSession {
    return URLSession.shared
  }
    //MARK: - Helper Functions
  func fetchPlaces( // fetches the different places from the GoogleMap Place API
    near coordinate: CLLocationCoordinate2D,
    radius: Double,
    types:[String],
    completion: @escaping PlacesCompletion
  ) -> Void {
    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate)&radius=\(radius)&rankby=prominence&sensor=true&key=\(googleApiKey)"
    let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
    urlString += "&types=\(typesString)"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
    
    guard let url = URL(string: urlString) else {
      completion([])
      return
    }
    
    if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
      task.cancel() // frees allocated ressources after the task is done
    }
    
    placesTask = session.dataTask(with: url) { data, response, _ in
      guard let data = data else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      guard let placesResponse = try? decoder.decode(GooglePlace.Response.self, from: data) else { // Decoding the JSON Response from the API
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      
      if let errorMessage = placesResponse.errorMessage {
        print(errorMessage)
      }
      
      DispatchQueue.main.async {
        completion(placesResponse.results)
      }
    }
    placesTask?.resume()
  }
}
