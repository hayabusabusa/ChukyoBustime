//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/09.
//

import Dependencies
import DependenciesMacros
import Foundation

/// ローカルの保存領域にデータを保存、読み込みするクライアント.
///
/// - note: AppGroups を考慮したディレクトリに保存を行う.
@DependencyClient
public struct FileClient {
    /// データ保存する.
    public var write: @Sendable (_ data: Data, _ name: String) throws -> Void
    /// データを読み込む.
    public var load: @Sendable (_ name: String) throws -> Data
    /// データを削除する.
    public var remove: @Sendable (_ name: String) -> Void
    /// 全てのデータを削除する.
    public var removeAll: @Sendable () -> Void
}

// MARK: - Dependency

extension FileClient: TestDependencyKey {
    public static var previewValue: FileClient {
        .init { data, name in
            // 何もしない.
        } load: { name in
            Data()
        } remove: { name in
            // 何もしない
        } removeAll: {
            // 何もしない
        }
    }

    public static var testValue: FileClient = Self.init()
}

extension DependencyValues {
    public var fileClient: FileClient {
        get { self[FileClient.self] }
        set { self[FileClient.self] = newValue }
    }
}
