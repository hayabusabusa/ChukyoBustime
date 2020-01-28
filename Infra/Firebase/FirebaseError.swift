//
//  FirebaseError.swift
//  Infra
//
//  Created by 山田隼也 on 2020/01/28.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public enum FirebaseError: Error {
    case dateNotFound
}

extension FirebaseError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dateNotFound:
            return ""
        }
    }
}
