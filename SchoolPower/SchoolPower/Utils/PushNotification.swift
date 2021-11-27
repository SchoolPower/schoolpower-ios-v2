//
//  PushNotification.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import Foundation
import UserNotifications
import Alamofire
import UIKit

class PushNotification {
    static func ifAuthorized(then: @escaping () -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            let authorization = settings.authorizationStatus
            guard authorization == .authorized || authorization == .provisional else { return }
            then()
        }
    }
}

// MARK: Remote Push Notification
extension PushNotification {
    static func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { (granted, error) in
                if let error = error {
                    print("Error requesting notification authorization: \(error)")
                }
                guard granted else { return }
                ifAuthorized {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
    }
    
    static func sendDeviceTokenToServer(tokenData: Data) {
        let tokenString = tokenData
            .map { data in String(format: "%02.2hhx", data) }
            .joined()
        
        print("Registered Push Notification Device Token: \(tokenString).")
        
        AF.request(
            Constants.registerAPNSDeviceTokenURL,
            method: .post,
            parameters: [
                "device_token": tokenString
            ],
            encoder: JSONParameterEncoder.default
        )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString { response in
                switch response.result {
                case .success:
                    debugPrint("Successfully sent APNS device token to server: \(response.value ?? "")")
                case let .failure(error):
                    print("Error sending APNS device token to server: \(error)")
                }
            }
    }
}

// MARK: Local Push Notification
extension PushNotification {
    private static let sendNotificationDelaySeconds: Double = 1
    
    static func handleTestNotification(
        onComplete: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        ifAuthorized {
            sendLocalNotification(
                title: "Testing Notification",
                subtitle: "",
                body: "This is a test notification, please ignore it.",
                when: sendNotificationDelaySeconds
            )
            onComplete(.newData)
        }
    }
    
    static func handleRemoteNotification(
        onComplete: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        ifAuthorized {
            let settingsStore = SettingsStore.shared
            guard settingsStore.isNotificationEnabled else {
                onComplete(.failed)
                return
            }
            
            StudentDataStore.tryLoadAndIfSuccess { oldData in
                StudentDataStore.tryFetchAndIfSuccess(action: .job) { newData in
                    let (newAssignments, newAttendances) = StudentDataUtils.diff(oldData: oldData, newData: newData)
                    
                    if (newAssignments.isEmpty && newAssignments.isEmpty) {
                        onComplete(.noData)
                    }
                    
                    sendNewAssignmentsNotification(
                        newAssignments: newAssignments,
                        showGrades: settingsStore.showGradesInNotification,
                        showUngraded: settingsStore.notifyUngradedAssignments
                    )
                    sendNewAttendancesNotification(newAttendances: newAttendances)
                    
                    onComplete(.newData)
                }
            }
        }
    }
    
    static func sendNewAssignmentsNotification(
        newAssignments: [Assignment],
        showGrades: Bool,
        showUngraded: Bool
    ) {
        let assignmentsToShow = newAssignments.filter { it in showUngraded || it.hasGrade }
        
        guard !assignmentsToShow.isEmpty else { return }
        
        let body = assignmentsToShow.map({ assignment in
            var description = assignment.title
            if showGrades {
                description += " \(assignment.getGradeString()) (\(assignment.markForDisplay))"
            }
            return description
        }).joined(separator: "\n")
        
        sendLocalNotification(
            title: "Notification.NewAssignment.Title"
                .localized(assignmentsToShow.count),
            subtitle: "",
            body: body,
            when: sendNotificationDelaySeconds
        )
    }
    
    static func sendNewAttendancesNotification(newAttendances: [Attendance]) {
        guard !newAttendances.isEmpty else { return }
        
        let body = newAttendances.map({ attendance in
            var description = attendance.description_p
            if !attendance.courseName.isEmpty {
                description += " (\(attendance.courseName))"
            }
            return description
        }).joined(separator: "\n")
        
        sendLocalNotification(
            title: "Notification.NewAttendance.Title"
                .localized(newAttendances.count),
            subtitle: "",
            body: body,
            when: sendNotificationDelaySeconds
        )
    }
    
    static func sendLocalNotification(
        title: String,
        subtitle: String,
        body: String,
        when: Double // Send after seconds
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: when, repeats: false)
        let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
