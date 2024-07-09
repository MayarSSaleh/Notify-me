//
//  NotificationDetails.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import Foundation
import UIKit

class NotificationDetailViewController: UIViewController {

    @IBAction func back(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
    }
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationContentLabel: UILabel!
    
    var notificationTitle: String?
    var notificationContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(" notificationTitle\(notificationTitle)")
        print(" notificationContent\(notificationContent)")

        notificationTitleLabel.text = notificationTitle
        notificationContentLabel.text = notificationContent
        
        
    }
}
