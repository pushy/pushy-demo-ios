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
    @IBOutlet weak var registrationId: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for persisted registration ID
        if let registrationId = UserDefaults.standard.string(forKey: "pushyToken") {
            // Update UI to display registration ID
            onRegistrationSuccess(registrationId)
        }
        
        // Listen for registration result notification
        NotificationCenter.default.addObserver(self, selector: #selector(onRegistrationResult), name: Notification.Name("registrationResult"), object: nil)
    }
    
    func onRegistrationResult(notification: Notification) {
        // Get registration result dictionary from notification
        guard let registrationResult = notification.userInfo else {
            return
        }
        
        // Registration error?
        if let error = registrationResult["error"] {
            // Print error to console
            print("Registration failed: \(error)")
            
            // Update UI to reflect failure
            self.registrationId.text = "Registration failed"
            self.instructions.text = "(restart app to try again)"
            
            // Create an alert dialog with the error message
            let alert = UIAlertController(title: "Registration Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            // Add an action button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // Show the alert dialog
            self.present(alert, animated: true, completion: nil)
        }
        // Registration success?
        else if let registrationId = registrationResult["registrationId"] as? String {
            // Update UI to display registration ID
            onRegistrationSuccess(registrationId)
        }
    }
    
    func onRegistrationSuccess(_ registrationId: String) {
        // Already printed this registration ID?
        if (self.registrationId.text! == registrationId){
            return
        }
        
        // Print registration ID to console
        print("Pushy registration ID: \(registrationId)")
        
        // Update UI to display registration ID
        self.registrationId.text = registrationId
        self.instructions.text = "(copy from console)"
    }
}

