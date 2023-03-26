//
//  FileServiceTests.swift
//  
//
//  Created by Shunya Yamada on 2023/02/10.
//

import XCTest

@testable import Service

final class FileServiceTests: XCTestCase {
    private let service = FileService(with: "jp.shunya.yamada.ChukyoBustime.FileService.Tests")

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        service.removeAll()
    }

    func test_基本機能の確認() {
        let data = "test".data(using: .utf8)!

        XCTContext.runActivity(named: "任意のデータを保存して読み込みができること") { _ in
            service.store(data: data, for: "load")
            let stored = service.load(for: "load")!

            XCTAssertEqual(String(data: stored, encoding: .utf8), "test")
        }

        XCTContext.runActivity(named: "任意の保存済みのデータを削除できること") { _ in
            service.store(data: data, for: "remove")
            service.remove(for: "remove")
            let removed = service.load(for: "remove")

            XCTAssertNil(removed)
        }

        XCTContext.runActivity(named: "保存済みのキーで保存した場合は上書きされること") { _ in
            let data2 = "test2".data(using: .utf8)!

            service.store(data: data, for: "overwrite")
            service.store(data: data2, for: "overwrite")
            let stored = service.load(for: "overwrite")!

            XCTAssertEqual(String(data: stored, encoding: .utf8), "test2")
        }

        XCTContext.runActivity(named: "複数の保存済みのデータを削除できること") { _ in
            service.store(data: data, for: "removeAll1")
            service.store(data: data, for: "removeAll2")
            service.store(data: data, for: "removeAll3")
            service.removeAll()

            let stored1 = service.load(for: "removeAll1")
            let stored2 = service.load(for: "removeAll2")
            let stored3 = service.load(for: "removeAll3")

            XCTAssertNil(stored1)
            XCTAssertNil(stored2)
            XCTAssertNil(stored3)
        }
    }
}
