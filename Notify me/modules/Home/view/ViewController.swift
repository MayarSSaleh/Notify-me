//
//  ViewController.swift
//  Notify me
//
//  Created by mayar on 04/07/2024.
//

import UIKit
import UserNotifications
import RealmSwift

// make 3 options
// + sign
// notification by intervaol
// notifaction by time ... chosse from the calender time with repeating
// notifiy by location ... by map and distance from this location check the internet example
// show list by notification in the main screen may save it by realem
// delete , update option?


class ViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    var notifications: Results<NotificationObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        self.requestNotificationAuthorization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotifications()

    }
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                Alert.showAlert(title: "without permisiion the notification will not appear", uiView: self)
                print("Error: ", error)
            }
            
        }
    }
    
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Notification Type", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "At Time", style: .default, handler: { _ in
            self.navigateToCalenderViewModel()
        }))
        alert.addAction(UIAlertAction(title: "At Location", style: .default, handler: { _ in
            self.navigateToLocationViewModel()
        }))
        alert.addAction(UIAlertAction(title: "After a while", style: .default, handler: { _ in
            self.navigateToIntervalViewModel()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func navigateToIntervalViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController{
            vc.comeAsTimeInterval = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func navigateToCalenderViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController{
            vc.comeAsTimeInterval = false
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func navigateToLocationViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController{
            vc.comeAsMap = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
}

extension ViewController :UITableViewDataSource, UITableViewDelegate {
  
    func fetchNotifications() {
        do {
            let realm = try Realm()
            notifications = realm.objects(NotificationObject.self)
            print( " notifications\(notifications?.count)")
            print( " notifications\(notifications?.first)")

            table.reloadData()
        } catch let error {
            print("Failed to fetch notifications from Realm: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        if let notification = notifications?[indexPath.row] {
            cell.textLabel?.text = notification.title
            cell.detailTextLabel?.text = notification.content
//            cell.imageView?.image = UIImage(named: notify)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle row selection if needed
    }
}
