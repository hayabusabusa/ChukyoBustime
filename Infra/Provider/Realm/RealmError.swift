//
//  RealmError.swift
//  Infra
//
//  Created by 山田隼也 on 2020/03/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

enum RealmError: Error {
    case objectNotFound
}

extension RealmError: CustomStringConvertible {
    var description: String {
        switch self {
        case .objectNotFound: return "データベースに保存されたデータがありません"
        }
    }
}
