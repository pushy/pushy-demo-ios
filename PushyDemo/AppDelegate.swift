//
//  AppDelegate.swift
//  PushyDemo
//
//  Created by Pushy on 10/18/16.
//  Copyright © 2016 Pushy. All rights reserved.
//

import UIKit
import AudioToolbox
import Pushy

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize Pushy SDK
        let pushy = Pushy(UIApplication.shared)
        
        // Register the device for push notifications
        pushy.register({ (error, deviceToken) in
            // Prepare data to pass to ViewController
            var registrationResult: [AnyHashable: Any] = [:]
            
            // Pass error if exists
            if error != nil {
                registrationResult["error"] = error
            }
            else {
                // Pass device token to UI
                registrationResult["deviceToken"] = deviceToken
                
                // Persist the device token locally
                UserDefaults.standard.set(deviceToken, forKey: "pushyToken")
            }
            
            // Run on main thread
            DispatchQueue.main.async {
                // Post notification with registration result to be picked up by ViewController
                NotificationCenter.default.post(name: Notification.Name("registrationResult"), object: nil, userInfo: registrationResult)
            }
        })
        
        // Listen for push notifications
        pushy.setNotificationHandler({ (data, completionHandler) in
            // Print notification payload data
            print("Received notification: \(data)")
            
            // Fallback message
            var message = ""
            
            // Extract aps dictionary from notification data
            if let aps = data["aps"] as? [AnyHashable : Any] {
                // Extract alert message from aps dictionary
                if let alertMessage = aps["alert"] as? String {
                    // Populate message with customized alert message
                    message = alertMessage
                }
            }
            
            // Display the notification as an alert
            let alert = UIAlertController(title: "Incoming Notification", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            // Add an action button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // Show the alert dialog
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            // Play notification sound (cute tweet noise)
            AudioServicesPlaySystemSound(1016)
            
            // Vibrate the device
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // You must call this completion handler when you finish processing
            // the notification (after fetching background data, if applicable)
            completionHandler(UIBackgroundFetchResult.newData)
        })
        
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state. Here you can undo many of the changes made on entering the background.
        
        // Reset badge number on app icon
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Re-register for push notifications every time the demo app becomes active
        // (to retry a failed registration)
        _ = self.application(application, didFinishLaunchingWithOptions: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

