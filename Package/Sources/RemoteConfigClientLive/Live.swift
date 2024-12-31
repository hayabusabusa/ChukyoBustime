//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/08.
//

@_exported import RemoteConfigClient
import Dependencies
import FirebaseRemoteConfig
import Foundation

extension RemoteConfigClient: @retroactive DependencyKey {
    public static var liveValue: RemoteConfigClient {
        live()
    }

    private static func live() -> Self {
        let remoteConfig = RemoteConfig.remoteConfig()

        return .init {
            _ = try await remoteConfig.fetchAndActivate()
        } configuredValue: { key in
            remoteConfig[key.rawValue].stringValue
        }
    }
}
