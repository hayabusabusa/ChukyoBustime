//
//  UserNotificationRepository.swift
//  Infra
//
//  Created by 山田隼也 on 2020/05/16.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import SwiftDate
import UserNotifications

enum UserNotificationError: Error {
    case overFiveMinutes
}

extension UserNotificationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .overFiveMinutes:
            return "すでに5分前の時間を過ぎています"
        }
    }
}

// MARK: - Interface

public protocol UserNotificationRepository {
    func requestAuthorization() -> Single<Bool>
    func setNotification(at hour: Int, minute: Int) -> Completable
    func removeAllNotifications()
}

// MARK: - Implementation

public struct UserNotificationRepositoryImpl: UserNotificationRepository {
    
    public init() {}
    
    /// 通知の許可をリクエストする
    /// - Returns: 許可された or 許可済みの場合は `true`、許可されなかった or 許可されていない場合は `false`,
    public func requestAuthorization() -> Single<Bool> {
        return Single.create { observer in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    observer(.success(true))
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                        if let error = error {
                            observer(.error(error))
                        }
                        observer(.success(granted))
                    }
                default:
                    observer(.success(false))
                }
            }
            return Disposables.create()
        }
    }
    
    /// 指定した時間のローカル通知をセットする.
    /// - Parameters:
    ///   - hour: 通知を表示させる`時間`
    ///   - minute: 通知を表示させる `分`
    /// - Returns: 通知のセットが失敗した場合は `Error` が流れる.
    public func setNotification(at hour: Int, minute: Int) -> Completable {
        return Completable.create { observer in
            // NOTE: 5分前の時間を生成、時間と分を通知のタイミングにセット
            let today = DateInRegion(Date(), region: .current)
            let fiveMinAgo = DateInRegion(year: today.year, month: today.month, day: today.day, hour: hour, minute: minute, second: 0, nanosecond: 0, region: .current) - 5.minutes
            
            // NOTE: 5分前と今を比較
            if today >= fiveMinAgo {
                observer(.error(UserNotificationError.overFiveMinutes))
            }
            
            var dateMatching    = DateComponents()
            dateMatching.hour   = fiveMinAgo.hour
            dateMatching.minute = fiveMinAgo.minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: false)
            
            let content     = UNMutableNotificationContent()
            content.title   = ""
            content.body    = String(format: "🚍 もうすぐ %02i:%02i 発のバスが出発します。", hour, minute)
            content.sound   = .default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    observer(.error(error))
                }
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    /// 登録したローカル通知を取得する.
    /// - Returns: 時間( hour ) と分( minute ) のタプルを返す.
    public func getNotification() -> Single<(hour: Int, minute: Int)?> {
        return Single.create { observer in
            UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
                if let notification = notifications.first {
                    let date = notification.date
                    let dateInRegion = DateInRegion(date, region: .current)
                    observer(.success((hour: dateInRegion.hour, minute: dateInRegion.minute)))
                } else {
                    observer(.success(nil))
                }
            }
            return Disposables.create()
        }
    }
    
    /// セットした全ての通知を削除する.
    public func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
