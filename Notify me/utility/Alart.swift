//
//  Alart.swift
//  Notify me
//
//  Created by mayar on 06/07/2024.
//

import Foundation
import UIKit

class Alert{
    
    static func showAlert(title: String,uiView: UIViewController) {
        let alertController = UIAlertController(title: "Alert", message: title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        uiView.present(alertController, animated: true, completion: nil)
    }
}
