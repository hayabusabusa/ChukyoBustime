//
//  UserNotificationServiceProtocol.swift
//  
//
//  Created by Shunya Yamada on 2023/03/07.
//

import Foundation

public protocol UserNotificationServiceProtocol {
    /// 通知の利用の許諾をリクエストする.
    func authorize() async throws

    /// 通知を追加する.
    /// - Parameters:
    ///   - hour: 追加する通知の時間.
    ///   - minute: 追加する通知の分.
    func addNotification(hour: Int, minute: Int) async throws
}
