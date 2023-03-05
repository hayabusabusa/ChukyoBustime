//
//  UserDefaultsServiceTests.swift
//  
//
//  Created by Shunya Yamada on 2022/11/03.
//

import XCTest

@testable import Service

final class UserDefaultsServiceTests: XCTestCase {
    /// すでに保存されている値などを一時保存しておくための辞書配列.
    static private var storedValues: [UserDefaultsService.Key: Any] = [:]

    override class func setUp() {
        super.setUp()
        evacuateStoredValues()
    }

    override class func tearDown() {
        super.tearDown()
        applyStoredValues()
    }

    func test_基本機能の確認() {
        let service = UserDefaultsService()

        XCTContext.runActivity(named: "プリミティブな値が保存できること") { _ in
            let value = 0
            service.set(value: value, forKey: .initialTab)
            
            let storedValue = service.object(type: Int.self, forKey: .initialTab)
            XCTAssertEqual(storedValue, value)
        }

        XCTContext.runActivity(named: "Enum で定義した値が保存できること") { _ in
            let value = Stub.x
            service.set(value: value, forKey: .initialTab)

            let storedValue = service.object(type: Stub.self, forKey: .initialTab)
            XCTAssertEqual(storedValue, value)
        }

        XCTContext.runActivity(named: "保存した値が削除できること") { _ in
            let value = 1
            service.set(value: value, forKey: .initialTab)
            service.removeObject(forKey: .initialTab)

            let storedValue = service.object(type: Int.self, forKey: .initialTab)
            XCTAssertNil(storedValue)
        }
    }
}

private extension UserDefaultsServiceTests {
    enum Stub: String {
        case x
        case y
    }

    /// 現在保存している値などを一時退避.
    static func evacuateStoredValues() {
        let service = UserDefaultsService()
        if let initialTab = service.object(type: Int.self, forKey: .initialTab) {
            storedValues[.initialTab] = initialTab
        }
    }

    /// 退避した値を反映.
    static func applyStoredValues() {
        let service = UserDefaultsService()
        storedValues.forEach { element in
            service.set(value: element.value, forKey: element.key)
        }
    }
}
