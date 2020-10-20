//  AlertProtocol.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import UIKit

enum AlertButton: String {
    case ok
    case cancel
    case delete
    case settings
}

protocol AlertProtocol: UIViewController {
    func showAlert(title: String, message: String, buttons: [AlertButton], completion: @escaping (UIAlertController, AlertButton) -> Void)
}
extension AlertProtocol {
    
    func showAlert(title: String, message: String, buttons: [AlertButton] = [.ok], completion: @escaping (UIAlertController, AlertButton) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        buttons.forEach { button in
            let action = UIAlertAction(title: button.rawValue.capitalized, style: button == .delete ? .destructive : .default) { [alert, button] action in
                completion(alert, button)
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
