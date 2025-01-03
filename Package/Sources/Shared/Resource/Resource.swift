//
//  Resource.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/31.
//

import Foundation

/// 画像等のアセット系ファイルを公開するための実装.
public enum Resource {}

public extension Resource {
    /// 画像ファイル.
    enum Image: CaseIterable {
        case imgError
        case imgDisconnected
    }
}

// MARK: - Internal

extension Resource.Image {
    var imageResource: ImageResource {
        switch self {
        case .imgError:
            .imgError
        case .imgDisconnected:
            .imgDisconnected
        }
    }
}
