//
//  PushNotificationService.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        PushNotification.registerForPushNotifications()
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        PushNotification.sendDeviceTokenToServer(tokenData: deviceToken)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for Push Notification: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if let isTesting = userInfo["testing"] as? Bool,
           isTesting == true,
           let username = userInfo["to"] as? String,
           !username.isEmpty,
           username == AuthenticationStore.shared.username
        {
            PushNotification.handleTestNotification(onComplete: completionHandler)
            return
        }
        PushNotification.handleRemoteNotification(onComplete: completionHandler)
    }
}


