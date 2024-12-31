//
//  ArrayExtensionTests.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/31.
//

import XCTest
@testable import Shared

final class ArrayExtensionTests: XCTestCase {
    func testPopFirst() {
        XCTContext.runActivity(named: "配列から削除した要素を返すこと.") { _ in
            var array = [1, 2, 3]

            let element = array.popFirst()
            XCTAssertEqual(element, 1)
        }

        XCTContext.runActivity(named: "配列が空の場合は nil を返すこと.") { _ in
            var array: [Int] = []

            let element = array.popFirst()
            XCTAssertNil(element)
        }

        XCTContext.runActivity(named: "配列から全ての要素を削除できること.") { _ in
            var array = [1, 2, 3]

            let firstElement = array.popFirst()
            let secondElement = array.popFirst()
            let thirdElement = array.popFirst()
            let fourthElement = array.popFirst()

            XCTAssertEqual(firstElement, 1)
            XCTAssertEqual(secondElement, 2)
            XCTAssertEqual(thirdElement, 3)
            XCTAssertNil(fourthElement)
        }
    }
}
