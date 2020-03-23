//
//  Configurations.swift
//  Infra
//
//  Created by 山田隼也 on 2020/03/18.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

enum Configurations {
    // TODO: Setup app group.
    /// AppGroup で設定した共有コンテナのURL
    static let kAppGraoupURL: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.jp.shunya.yamada.ChukyoBustime")!
}
