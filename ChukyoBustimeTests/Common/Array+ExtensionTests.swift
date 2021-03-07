//
//  Array+ExtensionTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/07.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
@testable import ChukyoBustime

class ArrayExtensionTests: XCTestCase {
    
    func testPopFirst() {
        XCTContext.runActivity(named: "Return removed element if exists.") { _ in
            var array = [1, 2, 3]
            
            let element = array.popFirst()
            XCTAssertEqual(element, 1)
        }
        
        XCTContext.runActivity(named: "Return nil if array is empty.") { _ in
            var array: [Int] = []
            
            let element = array.popFirst()
            XCTAssertNil(element)
        }
        
        XCTContext.runActivity(named: "Return removed element and nil.") { _ in
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
