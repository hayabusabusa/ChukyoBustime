//
//  UserNotificationService.swift
//  
//
//  Created by Shunya Yamada on 2023/03/05.
//

import Foundation
import ServiceProtocol
import UserNotifications

public protocol UserNotificationServiceProtocol {
    /// 通知の利用の許諾をリクエストする.
    func authorize() async throws

    /// 通知を追加する.
    /// - Parameters:
    ///   - hour: 追加する通知の時間.
    ///   - minute: 追加する通知の分.
    func addNotification(hour: Int, minute: Int) async throws
}

public enum UserNotificationError: Error {
    /// 通知の利用が許可されていない場合のエラー.
    case notAuthorized
    /// 通知が追加可能な 5 分前を過ぎている場合のエラー.
    case overFiveMinutes
}

public final class UserNotificationService: UserNotificationServiceProtocol {
    /// シングルトン.
    public static let shared = UserNotificationService()

    private let dateService: DateServiceProtocol
    private let notificationCenter = UNUserNotificationCenter.current()

    init(dateService: DateServiceProtocol = DateService()) {
        self.dateService = dateService
    }

    public func authorize() async throws {
        let settings = await notificationCenter.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized:
            return
        case .notDetermined:
            let result = try await notificationCenter.requestAuthorization()
            if result {
                return
            } else {
                throw UserNotificationError.notAuthorized
            }
        default:
            throw UserNotificationError.notAuthorized
        }
    }

    public func addNotification(hour: Int, minute: Int) async throws {
        let now = dateService.nowDate
        let requestingDate = dateService.today(hour: hour, minute: minute)
        // 通知を追加する時刻の 5 分前と今を比較して、すでに時間を過ぎていたらエラーを流す.
        let requestingDateFiveMinutesAgo = requestingDate.addingTimeInterval(-5 * 60)
        guard now <= requestingDateFiveMinutesAgo else {
            throw UserNotificationError.overFiveMinutes
        }

        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = String(format: "🚍 もうすぐ %02i:%02i 発のバスが出発します。", hour, minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: requestingDate.dateComponents,
                                                    repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        try await notificationCenter.add(request)
    }
}
