//
//  UserNotificationError.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/09.
//

import Foundation

public enum UserNotificationError: Error {
    /// 通知の利用が許可されていない場合のエラー.
    case notAuthorized
}

extension UserNotificationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notAuthorized:
            "通知の表示が許可されていません。\n設定から通知の表示を許可してください。"
        }
    }
}
