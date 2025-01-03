//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/09.
//

import Dependencies
import DependenciesMacros
import Foundation

/// ローカル通知の処理をまとめたクライアント.
@DependencyClient
public struct UserNotificationClient {
    /// 通知の利用許可をリクエストする.
    public var authorize: @Sendable () async throws -> Void
    /// ローカル通知を登録する.
    public var addNotification: @Sendable (_ date: Date) async throws -> Void
    /// 登録済みのローカル通知を全て削除する.
    public var removeAllNotifications: @Sendable () async throws -> Void
}

// MARK: - Dependency

extension UserNotificationClient: TestDependencyKey {
    public static var previewValue: UserNotificationClient {
        .init {
            // 何もしない.
        } addNotification: { _ in
            // 何もしない
        } removeAllNotifications: {
            // 何もしない
        }
    }

    public static var testValue: UserNotificationClient = Self.init()
}

extension DependencyValues {
    public var userNotificationClient: UserNotificationClient {
        get { self[UserNotificationClient.self] }
        set { self[UserNotificationClient.self] = newValue }
    }
}
