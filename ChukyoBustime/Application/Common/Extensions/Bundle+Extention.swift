//
//  Bundle+Extention.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

extension Bundle {
    var bundleShortVersionString: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
