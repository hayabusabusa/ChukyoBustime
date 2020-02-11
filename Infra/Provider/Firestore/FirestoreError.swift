//
//  FirestoreError.swift
//  Infra
//
//  Created by 山田隼也 on 2020/01/28.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public enum FirestoreError: Error {
    case dateNotFound
    case unknownDiagram
}

extension FirestoreError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dateNotFound:
            return "ダイアグラムの取得に失敗しました"
        case .unknownDiagram:
            return "無効なダイアグラム名です"
        }
    }
}
