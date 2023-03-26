//
//  FileService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/03.
//

import Foundation
import ServiceProtocol

/// ローカルの保存領域にデータを保存、読み込みする処理をまとめた Service クラス.
///
/// 保存領域は App Groups を利用するため共通の保存領域になる.
public final class FileService: FileServiceProtocol {

    public static let shared: FileService = .init()

    /// データ保存領域までのパス.
    private let path: URL

    init(with name: String = "jp.shunya.yamada.ChukyoBustime.FileService") {
        // NOTE: AppGroups の ID を指定して URL を生成
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.jp.shunya.yamada.ChukyoBustime") else {
            fatalError()
        }
        path = url.appendingPathComponent(name, isDirectory: true)
        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    }

    public func store(data: Data, for name: String) {
        let fileURL = path.appendingPathComponent(name, isDirectory: true)
        try? data.write(to: fileURL)
    }

    public func load(for name: String) -> Data? {
        let fileURL = path.appendingPathComponent(name, isDirectory: true)
        return try? Data(contentsOf: fileURL)
    }

    public func remove(for name: String) {
        let fileURL = path.appendingPathComponent(name, isDirectory: true)
        try? FileManager.default.removeItem(at: fileURL)
    }

    public func removeAll() {
        try? FileManager.default.removeItem(at: path)
        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
    }
}
