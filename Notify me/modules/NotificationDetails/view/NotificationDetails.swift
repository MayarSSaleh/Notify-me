//
//  NotificationDetails.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import Foundation
import UIKit

class NotificationDetailViewController: UIViewController {

    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationContentLabel: UILabel!
    
    var notificationTitle: String?
    var notificationContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the labels with the passed notification data
        notificationTitleLabel.text = notificationTitle
        notificationContentLabel.text = notificationContent
        
        
    }
}
