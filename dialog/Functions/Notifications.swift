//
//  Notifications.swift
//  dialog
//
//  Created by Bart Reardon on 27/9/2022.
//

import Foundation
import UserNotifications
import AppKit
import SwiftUI

func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Forground notifications.
    completionHandler([.banner, .sound])
}

func checkNotificationAuthorisation() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
        if let error = error {
            writeLog(error.localizedDescription, logLevel: .error)
            return
        }
    }
}

func sendNotification(title: String = "",
                      subtitle: String = "",
                      message: String = "",
                      acceptString: String = "Open",
                      acceptAction: String = "",
                      declineString: String = "Close",
                      declineAction: String = "") {
    let notification = UNUserNotificationCenter.current()
    // Define the custom actions.
    let acceptActionLabel = UNNotificationAction(identifier: "ACCEPT_ACTION_LABEL",
          title: acceptString,
          options: [])
    let declineActionLabel = UNNotificationAction(identifier: "DECLINE_ACTION_LABEL",
          title: declineString,
          options: [])
    var actions: [UNNotificationAction] = []

    if !acceptString.isEmpty && !declineString.isEmpty {
        actions = [acceptActionLabel, declineActionLabel]
    }

    // Define the notification type
    let meetingInviteCategory =
          UNNotificationCategory(identifier: "SD_NOTIFICATION",
          actions: actions,
          intentIdentifiers: [],
          hiddenPreviewsBodyPlaceholder: "",
                                 options: .customDismissAction)

    notification.setNotificationCategories([meetingInviteCategory])

    notification.getNotificationSettings { settings in
        guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }

        switch settings.authorizationStatus {
            case .authorized:
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                content.subtitle = subtitle
                content.userInfo = ["ACCEPT_ACTION": acceptAction,
                                "DECLINE_ACTION": declineAction ]
                content.categoryIdentifier = "SD_NOTIFICATION"

                // Create the request
                //let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: "SD_NOTIFICATION",
                            content: content, trigger: nil)

                // Schedule the request with the system.
                notification.add(request) { (error) in
                   if error != nil {
                       print(error?.localizedDescription ?? "Notification error")
                   }
                }
            case .provisional:
                print("Notification authorisation is provisional")
            case .denied:
                print("Notification authorisation is denied")
            case .notDetermined:
                print("Notification authorisation cannot be determined")
            default:
            print("Notifications aren't authorised")
        }
    }
}

func processNotification(response: UNNotificationResponse) {
    // Get action items from the notification

    let userInfo = response.notification.request.content.userInfo
    let acceptAction = userInfo["ACCEPT_ACTION"] as! String
    let declineAction = userInfo["DECLINE_ACTION"] as! String

    writeLog("acceptAction: \(acceptAction)")
    writeLog("declineAction: \(acceptAction)")

    switch response.actionIdentifier {
    case "ACCEPT_ACTION_LABEL", UNNotificationDefaultActionIdentifier:
        writeLog("user accepted", logLevel: .debug)
        notificationAction(acceptAction)

    case "DECLINE_ACTION_LABEL":
        writeLog("user declined", logLevel: .debug)
        notificationAction(declineAction)

    case UNNotificationDismissActionIdentifier:
        writeLog("notification was dismissed. doing nothing", logLevel: .debug)

    default:
       break
    }

}

func notificationAction(_ action: String) {
    writeLog("processing notification action \(action)")
    if action.contains("://") {
        openSpecifiedURL(urlToOpen: action)
    } else {
        _ = shell(action)
    }
}
