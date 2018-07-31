//
//  LocalNotificationHandlerViewController.swift
//  EngagementScenarios
//
//  Created on 7/30/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWEngagement

class LocalNotificationHandlerViewController: UIViewController {
    
    let firstName = "John"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        // Intercepts the local notification before it is sent from the SDK. Return true or false if you want the SDK to fire its own notification. In this case, we create our own app side and fire that.
        PWEngagement.setLocalNotificationHandler { [weak self] notification -> Bool in
            guard let strongSelf = self else {
                return false
            }
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.body = "Welcome \(strongSelf.firstName)! You will be called for your appointment shortly."
            notificationContent.sound = UNNotificationSound.default()
            
            let request = UNNotificationRequest(identifier: "notification", content: notificationContent, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            return false
        }
    }
}

extension LocalNotificationHandlerViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler( [.alert,.sound,.badge])
    }
}
