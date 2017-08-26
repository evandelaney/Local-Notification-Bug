//
//  Copyright © 2017 Fish Hook LLC. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    fileprivate let center = UNUserNotificationCenter.current()
    
    @IBOutlet fileprivate var errorLabel: UILabel?
}

private extension ViewController {
    
    @IBAction func requestPermissions(_ sender: UIButton)
    {
        center.requestAuthorization(options: []) { (granted, error) in
            if granted {
                sender.isEnabled = false
            }
            else {
                self.errorLabel?.text = error?.localizedDescription
            }
        }
    }
    
    @IBAction func scheduleNotification(_ sender: UIButton)
    {
//        center.removeAllDeliveredNotifications()
        
        guard let request = try? notificationRequest(for: "com.fishhook.test1", triggerTime: 5) else {
            fatalError()
        }
        
        center.add(request) { (error) in
            if let error = error {
                self.errorLabel?.text = error.localizedDescription
            }
        }
        
//        center.removeAllPendingNotificationRequests()
        
        guard let request2 = try? notificationRequest(for: "com.fishhook.test2", triggerTime: 10) else {
            fatalError()
        }
        
        center.add(request2) { (error) in
            if let error = error {
                self.errorLabel?.text = error.localizedDescription
            }
        }
    }
    
    func notificationRequest(for identifier: String, triggerTime time: TimeInterval?) throws -> UNNotificationRequest
    {
        guard let url = Bundle.main.url(forResource: "Week1-1", withExtension: "png") else {
            fatalError("Programmer Error")
        }
        
        let attachment = try UNNotificationAttachment(identifier: "\(identifier).attachment",
                                                      url: url,
                                                      options: nil)
        
        let content = UNMutableNotificationContent()
        content.title = String.localizedUserNotificationString(forKey: "Test Title", arguments: nil)
        content.body = String.localizedUserNotificationString(forKey: " ", arguments: nil)
        content.attachments = [ attachment ]
//        content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
        
        var trigger: UNNotificationTrigger? = nil
        if let time = time {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: time,
                                                        repeats: false)
        }
        
        return UNNotificationRequest(identifier: "\(identifier).request",
            content: content,
            trigger: trigger)
    }
}
