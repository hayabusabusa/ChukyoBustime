//
//  EntityTests.swift
//  InfraTests
//
//  Created by 山田隼也 on 2020/09/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import XCTest
@testable import Infra

class EntityTests: XCTestCase {

    func test_Decodable準拠のオブジェクトがデコードできることを確認() {
        XCTContext.runActivity(named: "`BusTimeEntity` の配列が正しくデコードできることを確認") { _ in
            let data    = resource(name: .busTime, resourceType: .json)
            let entity  = try? JSONDecoder().decode([BusTimeEntity].self, from: data)
            XCTAssertNotNil(entity, "デコードに失敗しました")
        }
        
        XCTContext.runActivity(named: "`BusDateEntity` の配列が正しくデコードできることを確認") { _ in
            let data    = resource(name: .busDate, resourceType: .json)
            let entity  = try? JSONDecoder().decode([BusDateEntity].self, from: data)
            XCTAssertNotNil(entity, "デコードに失敗しました")
        }
        
        XCTContext.runActivity(named: "Firebase Remote Config のデータが正しくデコードできることを確認") { _ in
            let data    = resource(name: .remoteConfig, resourceType: .json)
            let entity  = try? JSONDecoder().decode(RCPdfUrlEntity.self, from: data)
            XCTAssertNotNil(entity, "デコードに失敗しました")
        }
    }
}
