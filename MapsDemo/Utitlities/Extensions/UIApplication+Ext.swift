//
//  UIApplication+Ext.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url) { status in
                print("Settings Opened \(status)")
            }
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
