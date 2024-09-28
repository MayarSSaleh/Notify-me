//
//  ViewController.swift
//  Notify me
//
//  Created by mayar on 04/07/2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    var storedNotificationViewModel = StoredNotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")

        storedNotificationViewModel.upComingNotificationPreparation = { [weak self] in
            DispatchQueue.main.async {
                self?.table.reloadData()
                self?.backgroundImage()
            }
        }
        
        self.requestNotificationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storedNotificationViewModel.fetchUpComingNotifications()
    }
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                Alert.showAlert(title: "Without permission the notification will not appear", uiView: self)
                print("Error: ", error)
            }
        }
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Notification Type: ", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "After a while", style: .default, handler: { _ in
            self.navigateToIntervalViewModel()
        }))
        
        alert.addAction(UIAlertAction(title: "At Date ", style: .default, handler: { _ in
            self.navigateToCalenderViewModel()
        }))
       
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
  
    private func backgroundImage() {
        if storedNotificationViewModel.upComingNotifications.isEmpty {
            let emptyStateImage = UIImage(named: "empty")
            let imageView = UIImageView(image: emptyStateImage)
            imageView.contentMode = .scaleAspectFit
            table.backgroundView = imageView
        } else {
            table.backgroundView = nil
        }
    }
}


// navigation
extension ViewController {
    
  private func navigateToIntervalViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? setNotificationDetails {
            vc.comeAsTimeInterval = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    private  func navigateToCalenderViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? setNotificationDetails {
            vc.comeAsTimeInterval = false
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

// show upcoming notification in table
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedNotificationViewModel.upComingNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let notification = storedNotificationViewModel.upComingNotifications[indexPath.row]
        cell.setUp(titleOfNotification: notification.title, contentOfNotification: notification.content, isTime: notification.isNotificationByTime ?? true, isLocation: notification.isNocationByLocation ?? false, location: notification.locationName ?? "", showingMessangeAfterTime: String(notification.showingMessangeAfterTime ?? ""), dateAndTime: notification.atTimeAndDate ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alert.showConfirmationAlert(title: "Alart", message: "Are you sure.you want to delete this notification?", uiView: self){
                self.storedNotificationViewModel.deleteUpComingNotification(at: indexPath.row)
            }
        }
    }
    
}
