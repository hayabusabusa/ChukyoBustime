//
//  ImageExtensionTests.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/01.
//

import SwiftUI
import XCTest
@testable import Shared

final class ImageExtensionTests: XCTestCase {
    func testInitialize() {
        let images = Resource.Image.allCases
                .map {
                    Image(resource: $0)
                }
        XCTAssertEqual(images.count, Resource.Image.allCases.count)
    }
}
