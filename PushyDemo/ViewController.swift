//
//  ViewController.swift
//  PushyDemo
//
//  Created by Pushy on 10/18/16.
//  Copyright © 2016 Pushy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var deviceToken: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for persisted device token
        if let deviceToken = UserDefaults.standard.string(forKey: "pushyToken") {
            // Update UI to display device token
            onRegistrationSuccess(deviceToken)
        }
        
        // Listen for registration result notification
        NotificationCenter.default.addObserver(self, selector: #selector(onRegistrationResult), name: Notification.Name("registrationResult"), object: nil)
    }
    
    @objc func onRegistrationResult(notification: Notification) {
        // Get registration result dictionary from notification
        guard let registrationResult = notification.userInfo else {
            return
        }
        
        // Registration error?
        if let error = registrationResult["error"] {
            // Print error to console
            print("Registration failed: \(error)")
            
            // Update UI to reflect failure
            self.deviceToken.text = "Registration failed"
            self.instructions.text = "(restart app to try again)"
            
            // Create an alert dialog with the error message
            let alert = UIAlertController(title: "Registration Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            // Add an action button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // Show the alert dialog
            self.present(alert, animated: true, completion: nil)
        }
        // Registration success?
        else if let deviceToken = registrationResult["deviceToken"] as? String {
            // Update UI to display device token
            onRegistrationSuccess(deviceToken)
        }
    }
    
    func onRegistrationSuccess(_ deviceToken: String) {
        // Already displaying this device token?
        if (self.deviceToken.text! == deviceToken){
            return
        }
        
        // Print device token to console
        print("Pushy device token: \(deviceToken)")
        
        // Update UI to display device token
        self.deviceToken.text = deviceToken
        self.instructions.text = "(copy from console)"
    }
}

