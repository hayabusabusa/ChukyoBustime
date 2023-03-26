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
    var version: String { get }
    /// 起動時に表示するタブの設定を返す.
    var initialTab: Int { get }
    /// 起動時に表示するタブを切り替える.
    /// - Returns: 切り替え後のタブの値.
    func toggleTab() -> Int
}

final class SettingModel: SettingModelProtocol {
    private let userDefaultsService: UserDefaultsServiceProtocol

    init(userDefaultsService: UserDefaultsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
    }

    var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    var initialTab: Int {
        guard let stored = userDefaultsService.object(type: Int.self, forKey: .initialTab) else {
            // 値がない場合は初期値として `0` を設定する.
            userDefaultsService.set(value: 0, forKey: .initialTab)
            return 0
        }
        return stored
    }

    func toggleTab() -> Int {
        guard let stored = userDefaultsService.object(type: Int.self, forKey: .initialTab) else {
            // 初期値 0 が設定されているため `nil` のケースはなしとする.
            return 0
        }
        let newValue = stored == 0 ? 1 : 0
        userDefaultsService.set(value: newValue, forKey: .initialTab)
        return newValue
    }
}
