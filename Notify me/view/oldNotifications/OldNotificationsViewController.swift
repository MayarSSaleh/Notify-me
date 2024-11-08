//
//  OldNotificationsViewController.swift
//  Notify me
//
//  Created by mayar on 13/07/2024.
//

import UIKit

class OldNotificationsViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var storedNotificationViewModel = StoredNotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        storedNotificationViewModel.OldNotificationsReady = { [weak self] in
            DispatchQueue.main.async {
                self?.table.reloadData()
                self?.backgroundImage()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storedNotificationViewModel.fetchOldNotifications()
    }
    
    private func backgroundImage() {
        if storedNotificationViewModel.oldNotifications.isEmpty {
            let emptyStateImage = UIImage(named: "empty")
            let imageView = UIImageView(image: emptyStateImage)
            imageView.contentMode = .scaleAspectFit
            table.backgroundView = imageView
        } else {
            table.backgroundView = nil
        }
    }
}

extension OldNotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedNotificationViewModel.oldNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let notification = storedNotificationViewModel.oldNotifications[indexPath.row]
        cell.setUp(titleOfNotification: notification.title, contentOfNotification: notification.content, isTime: notification.isNotificationByTime ?? true, isLocation: notification.isNocationByLocation ?? false, location: notification.locationName ?? "", showingMessangeAfterTime: String(notification.showingMessangeAfterTime ?? ""), dateAndTime: notification.atTimeAndDate ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alert.showConfirmationAlert(title: "Alart", message: "Are you sure.you want to remove this notification from history?", uiView: self){
                self.storedNotificationViewModel.deleteNotificationFromHistory(at: indexPath.row)
            }
        }
    }
    
}
