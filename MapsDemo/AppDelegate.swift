//
//  AppDelegate.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//
import UIKit
import GoogleMaps

let googleApiKey = "AIzaSyBdGF0v_FG-7wU77AwI_QE7CqpgkI_GLCk"     //"AIzaSyAAZce9ODvwAh9ZeANRLsM8ur-e0c7FW5o"

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
