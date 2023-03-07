//
//  RemoteConfigServiceProtocol.swift
//  
//
//  Created by Shunya Yamada on 2023/03/07.
//

import Foundation
import Shared

public protocol RemoteConfigServiceProtocol {
    /// Remote Config からデータを取得する.
    func fetchActivate() async throws

    /// Remote Config に設定した値を取り出す.
    /// - Parameters:
    ///   - key: 値に設定したキー.
    ///   - type: 値の型.
    /// - Returns: 型変換した値.
    func configValue<T: Decodable>(for key: RemoteConfigKey, type: T.Type) -> T?
}
