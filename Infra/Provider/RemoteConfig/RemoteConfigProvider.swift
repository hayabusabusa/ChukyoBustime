//
//  RemoteConfigProvider.swift
//  Infra
//
//  Created by 山田隼也 on 2020/02/08.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseRemoteConfig

public final class RemoteConfigProvider {
    
    // MARK: Singleton
    
    public static let shared: RemoteConfigProvider = .init()
    
    // MARK: Propeties
    
    public let remoteConfig: RemoteConfig = .remoteConfig()
    
    public enum Key: String {
        case pdfUrl = "pdf_url"
    }
    
    // MARK: Initializer
    
    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    // MARK: Remote config
    
    /// Firebase側からRemoteConfigの値をフェッチする.
    ///
    /// - Note:
    ///     RemoteConfig から値を取得する前にフェッチを行い、以降はフェッチした値を利用する.
    public func fetchAndActivate() -> Completable {
        return Completable.create { observer in
            self.remoteConfig.fetchAndActivate { (status, error) in
                if let error = error {
                    observer(.error(error))
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    /// 指定したキーに対応するRemoteConfigの値を返す.
    ///
    /// - Note:
    ///     JSON形式の値でなかった場合はエラーを返す.
    /// - Parameters:
    ///   - key: 取得したい値に対応するキー
    ///   - configType: `RemoteConfigType`を継承した取得する値の型
    public func getConfigValue<T: RemoteConfigType>(for key: Key, configType: T.Type) -> Single<T> {
        return Single.create { observer in
            if let data = self.remoteConfig[key.rawValue].stringValue?.data(using: .utf8) {
                do {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(value))
                } catch {
                    observer(.failure(error))
                }
            } else {
                observer(.failure(RemoteConfigError.notJsonValue))
            }
            return Disposables.create()
        }
    }
}
