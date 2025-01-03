//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/09.
//

import Dependencies
import Foundation
import SwiftDate
import UserNotifications
import UserNotificationClient

extension UserNotificationClient: DependencyKey {
    public static var liveValue: UserNotificationClient {
        Self.live()
    }

    private static func live() -> Self {
        return .init {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            switch settings.authorizationStatus {
            case .authorized:
                return
            case .notDetermined:
                let result = try await UNUserNotificationCenter.current()
                    .requestAuthorization(
                        options: [
                            .alert,
                            .badge
                        ]
                    )
                if result {
                    return
                } else {
                    throw UserNotificationError.notAuthorized
                }
            default:
                throw UserNotificationError.notAuthorized
            }
        } addNotification: { date in
            let content = UNMutableNotificationContent()
            content.title = ""
            content.body = String(
                format: "🚍 もうすぐ %02i:%02i 発のバスが出発します。",
                date.hour,
                date.minute
            )
            // 通知は 1 回だけ表示する.
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: date.dateComponents,
                repeats: false
            )
            // 被らない ID にするため `UUID().uuidString` を指定する
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )

            try await UNUserNotificationCenter.current().add(request)
        } removeAllNotifications: {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
}
