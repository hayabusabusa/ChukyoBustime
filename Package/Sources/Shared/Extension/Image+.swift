//
//  Image+.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/31.
//

import SwiftUI

public extension Image {
    /// `Shared` モジュール内に追加した画像ファイルを指定して初期化する
    /// - Parameter resource: 画像ファイルのリソース名
    init(resource: Resource.Image) {
        self.init(resource.imageResource)
    }
}
