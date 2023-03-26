//
//  RemoteConfigService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift
import ServiceProtocol
import Shared

public final class RemoteConfigService: RemoteConfigServiceProtocol {
    /// シングルトン.
    public static let shared: RemoteConfigService = .init()

    private let remoteConfig = RemoteConfig.remoteConfig()

    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }

    public func fetchActivate() async throws {
        let _ = try await remoteConfig.fetchAndActivate()
        return
    }

    public func configValue<T: Decodable>(for key: RemoteConfigKey, type: T.Type) -> T? {
        guard let data = remoteConfig[key.rawValue].stringValue?.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(type, from: data) else { return nil }
        return decoded
    }
}
