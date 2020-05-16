//
//  UserNotificationRepository.swift
//  Infra
//
//  Created by 山田隼也 on 2020/05/16.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import UserNotifications

// MARK: - Interface

public protocol UserNotificationRepository {
    func requestAuthorization() -> Single<Bool>
    func setNotification(at hour: Int, minute: Int) -> Completable
    func removeAllNotifications()
}

// MARK: - Implementation

public struct UserNotificationRepositoryImpl: UserNotificationRepository {
    
    /// 通知の許可をリクエストする
    /// - Returns: 許可された or 許可済みの場合は `true`、許可されなかった or 許可されていない場合は `false`,
    public func requestAuthorization() -> Single<Bool> {
        return Single.create { observer in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    observer(.success(true))
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, error) in
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
            var dateMatching    = DateComponents()
            dateMatching.hour   = hour
            dateMatching.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: false)
            
            let content     = UNMutableNotificationContent()
            content.title   = ""
            content.body    = "もうすぐ \(hour):\(minute) のバスが出発します"
            
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
    
    /// セットした全ての通知を削除する.
    public func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
