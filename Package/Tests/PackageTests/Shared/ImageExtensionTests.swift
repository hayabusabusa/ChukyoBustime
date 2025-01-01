//
//  ImageExtensionTests.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/01.
//

import SwiftUI
import Testing
@testable import Shared

struct ImageExtensionTests {
    @Test
    func initialize() async throws {
        let images = Resource.Image.allCases
                .map {
                    Image(resource: $0)
                }
        #expect(images.count == Resource.Image.allCases.count)
    }
}
