//
//  RemoteConfigService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

public protocol RemoteConfigServiceProtocol {
    /// Remote Config からデータを取得する.
    func fetchActivate() async throws

    /// Remote Config に設定した値を取り出す.
    /// - Parameters:
    ///   - key: 値に設定したキー.
    ///   - type: 値の型.
    /// - Returns: 型変換した値.
    func configValue<T: Decodable>(for key: RemoteConfigService.Key, type: T.Type) -> T?
}

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

    public func configValue<T: Decodable>(for key: RemoteConfigService.Key, type: T.Type) -> T? {
        guard let data = remoteConfig[key.rawValue].stringValue?.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(type, from: data) else { return nil }
        return decoded
    }
}

public extension RemoteConfigService {
    /// Remote Config の設定値に利用するキー.
    enum Key: String, CaseIterable {
        /// カレンダーと時刻表の PDF の URL をまとめたデータを取得するキー.
        case pdfURL = "pdf_url"
    }
}
