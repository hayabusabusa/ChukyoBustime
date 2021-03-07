//
//  MockError.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/26.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation

enum MockError: Error {
    case somethingWentWrong
}

extension MockError: CustomStringConvertible {
    var description: String {
        switch self {
        case .somethingWentWrong:
            return "TEST"
        }
    }
}
