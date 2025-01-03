//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/08.
//

import Dependencies
import DependenciesMacros
import Foundation
import Shared

@DependencyClient
public struct RemoteConfigClient {
    /// Remote Config からデータを取得する.
    public var fetchActivate: @Sendable () async throws -> Void
    /// Remote Config に設定した値を取り出す.
    public var configuredValue: @Sendable (_ key: RemoteConfigKey) throws -> String
    
    /// Remote Config に設定した値を取り出す.
    /// - Parameters:
    ///   - key: 値に設定したキー.
    ///   - type: 値の型.
    /// - Returns: 型変換した値.
    public func configuredValue<T>(
        for key: RemoteConfigKey,
        type: T.Type
    ) throws -> T? where T: Decodable {
        guard let data = try? configuredValue(key: key).data(using: .utf8),
              let decoded = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return decoded
    }
}

// MARK: - Dependency

extension RemoteConfigClient: TestDependencyKey {
    public static var previewValue: RemoteConfigClient {
        .init {
            // 何もしない.
        } configuredValue: { _ in
            "Preview"
        }
    }

    public static var testValue: RemoteConfigClient = Self.init()
}

extension DependencyValues {
    public var remoteConfigClient: RemoteConfigClient {
        get { self[RemoteConfigClient.self] }
        set { self[RemoteConfigClient.self] = newValue }
    }
}
