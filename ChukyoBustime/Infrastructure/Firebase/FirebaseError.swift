//
//  FirebaseError.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

enum FirebaseError: Error {
    case dateNotFound
}

extension FirebaseError: CustomStringConvertible {
    var description: String {
        switch self {
        case .dateNotFound:
            return ""
        }
    }
}
