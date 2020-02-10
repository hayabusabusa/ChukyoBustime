//
//  RemoteConfigError.swift
//  Infra
//
//  Created by 山田隼也 on 2020/02/08.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public enum RemoteConfigError: Error {
    /// JSONの形式じゃない値を取得した場合のエラー
    case notJsonValue
}
