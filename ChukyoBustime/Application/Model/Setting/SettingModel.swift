//
//  SettingModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Interface

protocol SettingModel: AnyObject {
    func getSettings() -> Single<[SettingSectionType]>
}

// MARK: - Implementation

class SettingModelImpl: SettingModel {
    
    // MARK: Dependency
    
    // MARK: Initializer
    
    init() {}
    
    // MARK: Setting
    
    func getSettings() -> Single<[SettingSectionType]> {
        return Single.just([
            .config(rows: [
                .tabSetting(setting: "浄水駅行き")
            ]),
            .about(rows: [
                .version(version: Bundle.main.bundleShortVersionString ?? "unknown"),
                .agreement,
                .repository
            ])
        ])
    }
}
