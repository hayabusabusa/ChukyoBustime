//
//  ArrayExtensionTests.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/31.
//

import Testing
@testable import Shared

struct ArrayExtensionTests {
    @Test("Array.popFrist() のテスト")
    func popFirst() throws {
        var array1 = [1, 2, 3]
        let element1 = array1.popFirst()
        #expect(element1 == 1)

        var array2: [Int] = []
        let element2 = array2.popFirst()
        #expect(element2 == nil)

        var array3 = [1, 2, 3]
        let firstElement = array3.popFirst()
        let secondElement = array3.popFirst()
        let thirdElement = array3.popFirst()
        let fourthElement = array3.popFirst()
        #expect(firstElement == 1)
        #expect(secondElement == 2)
        #expect(thirdElement == 3)
        #expect(fourthElement == nil)
    }
}
