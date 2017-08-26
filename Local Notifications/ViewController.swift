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
        guard let url = Bundle.main.url(forResource: "test", withExtension: "jpeg") else {
            fatalError("Programmer Error")
        }
        
        let attachment: UNNotificationAttachment
        do {
            attachment = try UNNotificationAttachment(identifier: "com.fishhook.viewcontroller.attachment",
                                                          url: url,
                                                          options: nil)
        }
        catch {
            errorLabel?.text = error.localizedDescription
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = String.localizedUserNotificationString(forKey: "Test Title", arguments: nil)
        content.body = String.localizedUserNotificationString(forKey: "Test Body", arguments: nil)
        content.attachments = [ attachment ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                        repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "com.fishhook.viewcontroller.notification.request",
                                            content: content,
                                            trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                self.errorLabel?.text = error.localizedDescription
            }
        }
    }
}
