//
//  AppDelegate.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//
import UIKit
import GoogleMaps

let googleApiKey = "AIzaSyD5Pc99XpJeNjCaitz8nAzWiaHXvEN6By4"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
    

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey(googleApiKey)
    return true
  }
}
