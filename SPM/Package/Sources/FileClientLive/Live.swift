//
//  FileClientLive.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/09.
//

import Dependencies
import FileClient
import Foundation

extension FileClient: @retroactive DependencyKey {
    public static var liveValue: FileClient {
        Self.live()
    }

    private static func live() -> Self {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.jp.shunya.yamada.ChukyoBustime") else {
            fatalError("AppGroup ID is invalid and FileManager.default.containerURL is nil")
        }

        let path = url.appendingPathComponent(
            "jp.shunya.yamada.ChukyoBustime.FileService",
            isDirectory: true
        )
        try? FileManager.default.createDirectory(
            at: path,
            withIntermediateDirectories: true
        )

        return .init { data, name in
            let fileURL = path.appendingPathComponent(
                name,
                isDirectory: true
            )
            try data.write(to: fileURL)
        } load: { name in
            let fileURL = path.appendingPathComponent(
                name,
                isDirectory: true
            )
            return try Data(contentsOf: fileURL)
        } remove: { name in
            let fileURL = path.appendingPathComponent(
                name,
                isDirectory: true
            )
            try? FileManager.default.removeItem(at: fileURL)
        } removeAll: {
            try? FileManager.default.removeItem(at: path)
            try? FileManager.default.createDirectory(
                at: path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }

    }
}
