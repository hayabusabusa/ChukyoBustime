//
//  File.swift
//  
//
//  Created by Shunya Yamada on 2023/03/07.
//

import Foundation
import Shared

public protocol UserDefaultsServiceProtocol {
    /// プリミティブな値を保存する.
    /// - Parameters:
    ///   - value: `Any` に該当する値.
    ///   - key: 保存する際のキー.
    func set(value: Any, forKey key: UserDefaultsKey)

    /// Enum で定義された値を保存する.
    /// - Parameters:
    ///   - value: Enum の値.
    ///   - key: 保存する際のキー.
    func set<T: RawRepresentable>(value: T, forKey key: UserDefaultsKey)

    /// 保存されているプリミティブな値を読み込む.
    /// - Parameters:
    ///   - type: 読み込む値の型.
    ///   - key: 保存する際に指定したキー.
    /// - Returns: 保存されている値.
    func object<T>(type: T.Type, forKey key: UserDefaultsKey) -> T?

    /// 保存されている Enum の値を読み込む.
    /// - Parameters:
    ///   - type: 読み込む値の型.
    ///   - key: 保存する際に指定したキー.
    /// - Returns: 保存されている値.
    func object<T: RawRepresentable>(type: T.Type, forKey key: UserDefaultsKey) -> T?

    /// 保存されている値を削除する.
    /// - Parameter key: 保存する際に指定したキー.
    func removeObject(forKey key: UserDefaultsKey)
}
