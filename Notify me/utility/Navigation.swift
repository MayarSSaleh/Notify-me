//
//  Navigation.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import Foundation
import UIKit

class Navigation {
    
    static func ToNotifcationDetails(from viewController: UIViewController,title:String,content:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as? NotificationDetailViewController {
            vc.notificationContent = content
            vc.notificationTitle = title
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)
        }
    }
}
