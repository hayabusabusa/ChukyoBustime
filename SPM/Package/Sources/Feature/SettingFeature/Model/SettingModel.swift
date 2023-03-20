//
//  SettingModel.swift
//  
//
//  Created by Shunya Yamada on 2023/03/20.
//

import Foundation
import ServiceProtocol

protocol SettingModelProtocol {
    /// アプリのバージョンを返す.
    var version: String? { get }
    /// 起動時に表示するタブの設定を返す.
    var initialTab: Int? { get }
}

final class SettingModel: SettingModelProtocol {
    private let userDefaultsService: UserDefaultsServiceProtocol

    init(userDefaultsService: UserDefaultsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
    }

    var version: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    var initialTab: Int? {
        userDefaultsService.object(type: Int.self, forKey: .initialTab)
    }
}
